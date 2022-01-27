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

  def preorder(current = @root, list = [], &block)
    return nil if current.nil?

    block.call(current) if block_given?
    list.push(current.data) unless block_given?

    preorder(current.left, list, &block)
    preorder(current.right, list, &block)

    list unless block_given?
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

  def inorder(current = @root, list = [], &block)
    unless current.nil?
      inorder(current.left, list, &block)
      block.call(current) if block_given?
      list.push(current.data) unless block_given?
      inorder(current.right, list, &block)
    end

    list unless block_given?
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

  def postorder(current = @root, list = [], &block)
    unless current.nil?
      postorder(current.left, list, &block)
      postorder(current.right, list, &block)

      block.call(current) if block_given?
      list.push(current.data) unless block_given?
    end

    list unless block_given?
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def height(node = @root)
    if node.nil?
      -1
    else
      lefth = height(node.left)
      righth = height(node.right)
      1 + (lefth > righth ? lefth : righth)
    end
  end

  def depth(node = @root, current = @root, count = 0)
    return 0 if node == current
    return -1 if current.nil?

    if node < current.data
      count += 1
      depth(node, current.left, count)
    elsif node > current.data
      count += 1
      depth(node, current.right, count)
    else
      count
    end
  end

  def balanced?(current = @root)
    return true if current.nil?

    lefth = height(current.left)
    righth = height(current.right)

    return true if (lefth - righth).abs <= 1 && balanced?(current.left) & balanced?(current.right)

    false
  end

  def rebalance(_current = @root)
    list = inorder
    @root = build_tree(list) unless balanced?
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
tree.insert(70)
tree.delete(3)
tree.delete(23)
tree.delete(1)
# p tree
# p tree.preorder
# p tree.inorder
# p tree.postorder
# tree.postorder {|node| puts node.data}
# p tree.find(23)
# p tree.level_order
# tree.level_order {|node| puts node.data}
tree.pretty_print
# p tree.height(tree.find(324))
# p tree.depth(324)
# p tree.height
p tree.balanced?
tree.rebalance
p tree.balanced?
tree.pretty_print
