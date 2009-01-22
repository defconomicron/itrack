class PageView < ActiveRecord::Base
  def self.traffic(params)  
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    strftime = sanitize_sql_array(["%s", params[:strftime]])
    
    find_by_sql("
      select
        strftime('#{strftime}', created_at) as created_at,
        sum(page_views) as page_views,
        sum(new_visitors) as new_visitors,
        sum(return_visitors) as return_visitors,
        sum(visits) as visits
      from (
        select
          strftime('#{strftime}', created_at) as created_at,
          count(id) as page_views,
          count(new_visitor) as new_visitors,
          count(return_visitor) as return_visitors,
          count(new_visit) as visits
        from page_views
        where #{where}
        group by strftime('#{strftime}', created_at)
        
        union
        
        #{zero_buffer(params)}
      )
      group by strftime('#{strftime}', created_at)
      order by strftime('#{strftime}', created_at)
    ")
  end
  
  def self.http_accept_languages(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          http_accept_language,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              http_accept_language,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by http_accept_language
            
            union

            select http_accept_language, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                http_accept_language,
                1 as unique_visitor
              from page_views
              where #{where}
              group by http_accept_language, cookie_id
            ) as a
            group by http_accept_language
    
        ) as a
        group by http_accept_language
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end
  
  def self.http_user_agents(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          http_user_agent,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              http_user_agent,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by http_user_agent
            
            union

            select http_user_agent, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                http_user_agent,
                1 as unique_visitor
              from page_views
              where #{where}
              group by http_user_agent, cookie_id
            ) as a
            group by http_user_agent
    
        ) as a
        group by http_user_agent
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end
  
  def self.domains(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          domain,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              domain,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by domain
            
            union

            select domain, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                domain,
                1 as unique_visitor
              from page_views
              where #{where}
              group by domain, cookie_id
            ) as a
            group by domain
    
        ) as a
        group by domain
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end
  
  def self.urls(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          url,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              url,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by url
            
            union

            select url, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                url,
                1 as unique_visitor
              from page_views
              where #{where}
              group by url, cookie_id
            ) as a
            group by url
    
        ) as a
        group by url
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end
    
  def self.countries(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]
 
    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          country,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              country,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by country
            
            union

            select country, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                country,
                1 as unique_visitor
              from page_views
              where #{where}
              group by country, cookie_id
            ) as a
            group by country
    
        ) as a
        group by country
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end

  def self.regions(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"    
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          country,
          region,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              country,
              region,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by country, region
            
            union

            select country, region, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                country,
                region,
                1 as unique_visitor
              from page_views
              where #{where}
              group by country, region, cookie_id
            ) as a
            group by country, region
    
        ) as a
        group by country, region
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end

  def self.cities(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"    
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "url = :url" if params[:url]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:url => params[:url]) if params[:url]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language => params[:http_accept_language]) if params[:http_accept_language]

    where = sanitize_sql_array([ conditions1, conditions2 ])
    order = sanitize_sql_array(["%s", params[:order]])

    paginate_by_sql("
        select
          country,
          region,
          city,
          sum(page_views) as page_views,
          sum(new_visitors) as new_visitors,
          sum(return_visitors) as return_visitors,
          sum(visits) as visits,
          sum(unique_visitors) as unique_visitors
        from (
        
            select
              country,
              region,
              city,
              count(id) as page_views,
              count(new_visitor) as new_visitors,
              count(return_visitor) as return_visitors,
              count(new_visit) as visits,
              0 as unique_visitors
            from page_views
            where #{where}
            group by country, region, city
            
            union

            select country, region, city, 0 as page_views, 0 as new_visitors, 0 as return_vistors, 0 as visits, sum(unique_visitor) as unique_visitors
            from (
              select
                country,
                region,
                city,
                1 as unique_visitor
              from page_views
              where #{where}
              group by country, region, city, cookie_id
            ) as a
            group by country, region, city
    
        ) as a
        group by country, region, city
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end

  def self.clean
    query("delete from page_views where created_at < '#{1.week.ago.strftime("%Y-%m-%d %H:%M:%S")}'")
  end
  
  def self.domain_list(params)
    [''] + find_by_sql("
      select domain
      from page_views
      where
      created_at >= '#{params[:start_time]}'
      and
      created_at <= '#{params[:end_time]}'
      group by domain
      order by domain
    ").map {|r| r.domain}
  end
  
  private
  
    def self.query(str)
      connection.select_all(str)
    end
              
    def self.zero_buffer(params)
      strftime = sanitize_sql_array(["%s", params[:strftime]])
      a = params[:start_time]
      b = params[:end_time]
      page_views = []
      page_views << "select '#{a.strftime(strftime)}' as created_at, 0 as page_views, 0 as new_visitors, 0 as return_visitors, 0 as visits" while (a += eval("1.#{params[:period]}")) < b
      return page_views * " union "
    end
end
