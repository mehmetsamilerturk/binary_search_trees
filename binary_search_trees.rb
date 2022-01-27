# frozen_string_literal: true

class Node
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def preorder_traversal(current = @root)
    return nil if current.nil?

    print "#{current.data} -> "
    preorder_traversal(current.left)
    preorder_traversal(current.right)
  end

  def insert(value, current = @root)
    return Node.new(value) if current.nil?

    if value > current.data
      current.right = insert(value, current.right)
    else
      current.left = insert(value, current.left)
    end

    current
  end

  def delete(value, current = @root)
    return current if current.nil?

    if value < current.data
      current.left = delete(value, current.left)
    elsif value > current.data
      current.right = delete(value, current.right)
    else
      if current.left.nil?
        return current.right
      elsif current.right.nil?
        return current.left
      end

      current.data = min_value(current.right)
      current.right = delete(current.data, current.right)
    end

    current
  end

  def inorder_traversal(current = @root)
    unless current.nil?
      inorder_traversal(current.left)
      print "#{current.data} -> "
      inorder_traversal(current.right)
    end
  end

  def find(value, current = @root)
    return current if current.nil? || current.data == value

    return find(value, current.right) if current.data < value

    find(value, current.left)
  end

  def level_order(current = @root, queue = [], list = [])
    return if current.nil?

    queue.push(current)

    until queue.empty?
      current = queue.first

      yield(current) if block_given?
      list.push(current.data) unless block_given?

      queue.push(current.left) unless current.left.nil?
      queue.push(current.right) unless current.right.nil?
      queue.shift
    end

    list unless block_given?
  end

  private

  def min_value(current = @root)
    minv = current.data

    until current.left.nil?
      minv = current.left.data
      current = current.left
    end

    minv
  end

  def build_tree(array, start = 0, end_array = array.length - 1)
    return nil if start > end_array

    mid = ((start + end_array) / 2)
    root_node = Node.new(array[mid])
    root_node.left = build_tree(array, start, mid - 1)
    root_node.right = build_tree(array, mid + 1, end_array)
    root_node
  end
end

numbers = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]

tree = Tree.new(numbers)
# tree.insert(70)
# tree.delete(3)
# tree.delete(23)
# tree.insert(25)
# tree.delete(8)
# p tree
# tree.inorder_traversal
# tree.preorder_traversal
# p tree.find(23)
#p tree.level_order
#tree.level_order {|node| puts node.data}
