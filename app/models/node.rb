class Node < ActiveRecord::Base
	belongs_to :user
	acts_as_tree
	validates :title,:presence => {:message => "Write a name"}, :allow_blank => false

	extend ActsAsTree::TreeWalker

end
