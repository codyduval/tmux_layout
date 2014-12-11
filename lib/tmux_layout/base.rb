module TmuxLayout

  class CheckSum
    attr_accessor :config_string

    def initialize(config_string)
      @config_string = config_string
    end

    def csum
      csum = 0
      @config_string.each_char do |character|
        character = character.ord
        csum = (csum >> 1) + ((csum & 1) << 15);
        csum += character 
      end
      csum.to_s(16)
    end
  end

  class PaneNode
    attr_accessor :width, :height, :x_offset, :y_offset, :parent, :children, :left_or_right

    def initialize(width, height, x_offset=0, y_offset=0, left_or_right=nil)
      @width = width
      @height = height
      @x_offset = x_offset
      @y_offset = y_offset
      @left_or_right = left_or_right
      @children = []
    end

    def params
      "#{@width}x#{@height},#{@x_offset},#{@y_offset}"
    end

    def add(*children)
      children.flatten.each do |child|
        @children << child
        child.parent = self
      end
      self
    end

    def descendants(list = [])
      unless children.empty?
        children.each do |child|
          list << child
          child.descendants(list)
        end
      end
      list
    end

    def tree_as_string(list = [], tree_params = [], brackets = [])
      # Start string with width x height and offset for root node
      if tree_params.empty?
        tree_params << self.params
      end
      unless children.empty?
        children.each do |child|
          list << child
          if tree_params.count != 1 && invisible_pane?
            tree_params << ","
          elsif child.left_or_right == :left
            #if a child and parent have the same width, then it's being
            #split vertically.  Tmux indicates vertical splits
            #with square brackets.
            if (child.width == child.parent.width)
              tree_params << "["
              brackets << "]"
            #otherwise, it's a horizontal split, show that with a curly 
            #brace
            else
              tree_params << "{"
              brackets << "}"
            end
          end
          #if a pane splits in the same direction as its parent, then
          #don't print it (just a weird tmux thing).
          unless child.invisible_pane?
            tree_params << child.params
          end
          #just use 00 for the pane id - tmux throws this away
          #when using a layout string for building a new layout
          if child.window_pane?
            tree_params << ",00"
          end
          #If it's a leaf node, then close the brackets
          if (child.left_or_right == :right) &&
             (child.children.empty?)
            tree_params << brackets.pop
          end
          #keep recursing through the tree, passing any values
          #for the three_params or brackets that its collected
          #along the way
          child.tree_as_string(list, tree_params, brackets)
        end
        #Remember to close any remaining brackets or braces.
        tree_params << brackets.pop
      end
      tree_params.join 
    end

    def split_vertically(percentage)
      first_child_height = ((@height - (@height * percentage)).to_i)
      second_child_height = ((@height - first_child_height).to_i)
      first_child = PaneNode.new(@width, first_child_height, 0, 0, :left)
      second_child = PaneNode.new(@width, second_child_height, 0, 0, :right)

      add([first_child, second_child])

      first_child.x_offset = first_child.parent.x_offset 
      second_child.x_offset = second_child.parent.x_offset 

      first_child.y_offset = first_child.parent.y_offset 
      second_child.y_offset = second_child.parent.y_offset + second_child_height 
    end

    def split_horizontally(percentage)
      first_child_width = (@width - (@width * percentage)).to_i
      second_child_width = (@width - first_child_width).to_i
      first_child = PaneNode.new(first_child_width, @height, 0, 0, :left)
      second_child = PaneNode.new(second_child_width, @height, 0, 0, :right)

      add([first_child, second_child])

      first_child.x_offset = first_child.parent.x_offset 
      second_child.x_offset = second_child.parent.x_offset + second_child_width 

      first_child.y_offset = first_child.parent.y_offset 
      second_child.y_offset = second_child.parent.y_offset 
    end

    #Tmux doesn't print panes if they contain other panes AND have the
    #same split orientation of their parent.
    def invisible_pane?
      ((children.any? && parent) && 
        ((children.first.width == parent.width) ||
         (children.first.height == parent.height)))
    end
    
    #A window_pane actually shows a terminal
    def window_pane?
      if children == []
        true
      else
        false
      end
    end

    #A container_pane just contains other (viewable) window_panes 
    def container_pane?
      if children.any?
        true
      else
        false
      end
    end
  end

end
