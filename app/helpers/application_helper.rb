module ApplicationHelper
  def possessivize(nm)
    return nil if nm.blank?
    return 's' == nm[-1,1] ? nm + "'" : nm + "'s"
  end
end
