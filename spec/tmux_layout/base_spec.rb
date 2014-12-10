require "spec_helper"

module TmuxLayout
  describe CheckSum do
    it "should take and hold a string" do
      csum = CheckSum.new('HELLO')

      expect(csum.config_string).to eq('HELLO')
    end

    it "should return a checksum" do
      checksum = CheckSum.new('159x48,0,0{79x48,0,0,79x48,80,0}')
      csum_value = checksum.csum
      
      expect(csum_value).to eq('bb62')
    end
  end

  describe PaneNode do
    it "should hold the values for a panes width, height, and offset" do
      node = PaneNode.new(159, 48, 0, 0)

      expect(node.width).to eq(159)
    end

    it "should hold a reference for its parent (and children)" do
      node = PaneNode.new(159, 48, 0, 0)
      child = PaneNode.new(79, 48, 0, 0)

      node.add(child)

      expect(node.children).to include(child)
      expect(child.parent).to eq(node)
    end

    it "should split a window vertically by 75 percent" do
      node = PaneNode.new(159, 48, 0, 0)

      node.split_vertically(0.75)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      expect(first_child.height).to eq(12)
      expect(second_child.height).to eq(36)

    end

    it "should split a window horizontally by 35 percent" do
      node = PaneNode.new(159, 48, 0, 0)

      node.split_horizontally(0.35)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      expect(first_child.width).to eq(103)
      expect(second_child.width).to eq(56)
    end

    it "should add the correct offset after being split 50 percent" do
      node = PaneNode.new(178, 51, 0, 0)

      node.split_vertically(0.50)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      expect(first_child.y_offset).to eq(0)
      expect(second_child.y_offset).to eq(26)
    end

    it "should add the correct offset after being split 50 percent twice" do
      node = PaneNode.new(178, 51, 0, 0)
      node.split_vertically(0.50)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      second_child.split_horizontally(0.50)

      first_second_child = second_child.children[0]
      second_second_child = second_child.children[1]

      expect(first_second_child.x_offset).to eq(0)
      expect(second_second_child.x_offset).to eq(89)
      expect(second_second_child.y_offset).to eq(26)
    end

    it "should list all the descendants of a node" do
      node = PaneNode.new(178, 51, 0, 0)
      node.split_vertically(0.50)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      second_child.split_horizontally(0.50)

      first_second_child = second_child.children[0]
      second_second_child = second_child.children[1]

      second_second_second_child = second_second_child.children[1]

      list = node.tree_params
      binding.pry
    end
  end

end
