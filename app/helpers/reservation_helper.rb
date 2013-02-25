module ReservationHelper
  DEFAULT_SORT_COLUMN = 'reserve_date'
  DEFAULT_SORT_DIR = 'ASC'
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    total = Reservation.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    
    criteria = Reservation
    
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
  
  def self.get_filter_by(filters, pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    criteria, order = get_filter_criteria(filters, sort)
    total = criteria.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    
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
  
  def self.item_message(filters, pagenum, pagesize)
    total = 0
    if filters.blank?
      total = Reservation.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
      
    else
      criteria, order = get_filter_criteria(filters)
      total = criteria.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
    end
  end
  
  def self.get_filter_criteria(filters, sort = nil)
    name_keyword = "%#{filters[:name]}%"
    order = sort.present? ? sort.to_s : nil
    
    criteria = Reservation if criteria.blank?
    
    if filters[:reserve_date].present?
      criteria = criteria.where('reserve_date = ?', filters[:reserve_date])
    end
    
    if filters[:reserve_time].present?
      criteria = criteria.where('reserve_time = ?', filters[:reserve_time])
    end
    
    if filters[:name].present?
      criteria = criteria.where('name like ?', name_keyword)
    end
    
    if filters[:location] != 0
      criteria = criteria.where('location = ?', filters[:location])
    end
    
    return criteria, order
  end
end
