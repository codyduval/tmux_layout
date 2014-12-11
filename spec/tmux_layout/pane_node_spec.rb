require "spec_helper"

module TmuxLayout
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

    it "should produce a config string when split vertically then horizontally"do
      node = PaneNode.new(178, 51, 0, 0)
      node.split_vertically(0.50)

      children = node.children
      first_child = children[0]
      second_child = children[1]

      second_child.split_horizontally(0.50)

      first_second_child = second_child.children[0]
      second_second_child = second_child.children[1]

      second_second_second_child = second_second_child.children[1]

      list = node.tree_as_string

      expect(list).to eq("178x51,0,0[178x25,0,0,00178x26,0,26{89x26,0,26,0089x26,89,26,00}]")
    end

    it "should produce a config string when split vertically two times" do
      node = PaneNode.new(178, 51, 0, 0)
      node.split_vertically(0.50)

      children = node.children
      second_child = children[1]

      second_child.split_vertically(0.50)

      second_second_child = second_child.children[1]
      second_second_child.split_vertically(0.50)

      list = node.tree_as_string
      expect(list).to eq("178x51,0,0[178x25,0,0,00,178x13,0,26,00,,178x6,0,39,00,178x7,0,46,00]")
    end
  end

end
