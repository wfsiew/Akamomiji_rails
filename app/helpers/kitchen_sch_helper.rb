module KitchenSchHelper
  DEFAULT_SORT_COLUMN = 'week'
  DEFAULT_SORT_DIR = 'ASC'
  
  def self.get_all(pagenum = 1, pagesize = ApplicationHelper::Pager.default_page_size,
    sort = ApplicationHelper::Sort.new(DEFAULT_SORT_COLUMN, DEFAULT_SORT_DIR))
    total = KitchenSch.count
    pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
    order = sort.to_s
    
    has_next = pager.has_next? ? 1 : 0
    has_prev = pager.has_prev? ? 1 : 0
    
    if sort.column == 's.name'
      criteria = get_join({}, sort)
      
    else
      criteria = KitchenSch
    end
    
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
      total = KitchenSch.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
      
    else
      criteria, order = get_filter_criteria(filters)
      total = criteria.count
      pager = ApplicationHelper::Pager.new(total, pagenum, pagesize)
      return pager.item_message
    end
  end
  
  private
  
  def self.get_filter_criteria(filters, sort = nil)
    name_keyword = "%#{filters[:name]}%"
    order = sort.present? ? sort.to_s : nil
    
    if filters[:name].present? || sort.present?
      criteria = get_join(filters, sort)
    end
    
    criteria = KitchenSch if criteria.blank?
    
    if filters[:category] != 0
      criteria = criteria.where('category = ?', filters[:category])
    end
    
    if filters[:name].present?
      criteria = criteria.where('s.name like ?', name_keyword)
    end
    
    if filters[:location] != 0
      criteria = criteria.where('location = ?', filters[:location])
    end
    
    if filters[:week] != 0
      criteria = criteria.where('week = ?', filters[:week])
    end
    
    return criteria, order
  end
  
  def self.get_join(filters, sort = nil)
    joinhash = {}
    
    if filters.any?
      if filters[:name].present?
        q = KitchenSch.joins('inner join staff s on kitchen_sch.staff_id = s.id')
        joinhash[:name] = true
      end
    end
    
    if sort.present?
      if sort.column == 's.name'
        if !joinhash.has_key?(:name)
          q = KitchenSch.joins('left outer join staff e on kitchen_sch.staff_id = s.id')
        end
      end
    end
    
    q
  end
end
