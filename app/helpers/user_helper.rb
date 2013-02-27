module UserHelper
  DEFAULT_SORT_COLUMN = 'role'
  DEFAULT_SORT_DIR = 'ASC'
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    total = User.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = User.order(order).all(offset: pager.lower_bound, limit: pager.pagesize)
    {
      item_msg: pager.item_message, 
      hasnext: has_next, 
      hasprev: has_prev, 
      nextpage: pagenum + 1, 
      prevpage: pagenum - 1,
      list: list, 
      sortcolumn: sort.column, 
      sortdir: sort.direction
    }
  end
  
  def self.get_filter_by(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_criteria(sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    list = criteria.order(order).all(offset: pager.lower_bound, limit: pager.pagesize)
    {
      item_msg: pager.item_message, 
      hasnext: has_next, 
      hasprev: has_prev, 
      nextpage: pagenum + 1, 
      prevpage: pagenum - 1,
      list: list, 
      sortcolumn: sort.column, 
      sortdir: sort.direction
    }
  end
  
  def self.get_errors(errors)
    { error: 1, errors: errors }
  end
  
  private
  
  def self.get_filter_criteria(sort = nil)
    order = sort.present? ? sort.to_s : nil
    criteria = User
    
    return criteria, order
  end
end
