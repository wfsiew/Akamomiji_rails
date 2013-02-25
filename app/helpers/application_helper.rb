module ApplicationHelper
  # Pager object for paging purpose
  class Pager
    attr_accessor :total, :pagenum
    attr_reader :pagesize

    @@default_page_size = 50
    def initialize(total, pagenum, pagesize)
      @total = total
      @pagenum = pagenum
      set_pagesize(pagesize)
    end

    def pagesize=(pagesize)
      set_pagesize(pagesize)
    end

    # Get the paging message.
    def item_message
      Utils.item_message(total, pagenum, pagesize)
    end

    # Get the lower bound of the page.
    def lower_bound
      (pagenum - 1) * pagesize
    end

    # Get the upper bound of the page.
    def upper_bound
      upperbound = pagenum * pagesize
      if total < upperbound
        upperbound = total
      end
      upperbound
    end

    # Checks whether the pager has next page.
    def has_next?
      total > upper_bound ? true : false
    end

    # Checks whether the pager has previous page.
    def has_prev?
      lower_bound > 0 ? true : false
    end

    # Get the total pages.
    def total_pages
      (Float(total) / pagesize).ceil
    end

    # Get the default page size.
    def self.default_page_size
      @@default_page_size
    end

    private

    def set_pagesize(pagesize)
      if (total < pagesize || pagesize < 1) && total > 0
        @pagesize = total

      else
        @pagesize = pagesize
      end
    end
  end

  module Utils
    require 'time'

    # Get the paging message.
    def self.item_message(total, pagenum, pagesize)
      x = (pagenum - 1) * pagesize + 1
      y = pagenum * pagesize

      if total < y
      y = total
      end

      if total < 1
        return ""
      end

      "#{x} to #{y} of #{total}"
    end

    # Checks for numeric.
    def self.numeric?(val)
      true if Float(val) rescue false
    end
  end

  class Sort
    attr_accessor :column, :direction
    def initialize(column, dir = 'ASC')
      @column = column
      @direction = dir
    end

    def to_s
      "#{@column} #{@direction}"
    end
  end

  class Location
    def self.data
      [['Restaurant', 1], ['Cuisine', 2]]
    end

    def self.str(i)
      case i
      when 1
        'Restaurant'

      when 2
        'Cuisine'

      else
        ''
      end
    end
  end
  
  class ReservationStatus
    def self.data
      [['Active', 1], ['Closed', 2]]
    end
    
    def self.str(i)
      case i
      when 1
        'Active'
        
      when 2
        'Closed'
        
      else
        ''
      end
    end
  end

  class UserRole
    def self.data
      [['Admin', 1], ['Normal User', 2]]
    end
    
    def self.str(i)
      case i
      when 1
        'Admin'
        
      when 2
        'Normal User'
        
      else
        ''
      end
    end
  end

  class StaffStatus
    def self.data
      [['Active', 1], ['Resigned', 2]]
    end
    
    def self.str(i)
      case i
      when 1
        'Active'
        
      when 2
        'Resigned'
        
      else
        ''
      end
    end
  end

  def self.localtime(t)
    t.in_time_zone('Kuala Lumpur')
  end

  def self.date_fmt
    '%d-%m-%Y'
  end

  def self.time_fmt
    '%H:%M'
  end
end
