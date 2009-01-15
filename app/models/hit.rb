class Hit < ActiveRecord::Base
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
        sum(hits) as hits,
        sum(visitors) as visitors,
        sum(visits) as visits
      from (
        select
          strftime('#{strftime}', created_at) as created_at,
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
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
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
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
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
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
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
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
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
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
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
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
          region,
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
        group by region
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
          city,
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{where}
        group by city
        order by #{order}
      ",
      :page     => params[:page],
      :per_page => params[:per_page]
    )
  end

  def self.clean
    query("delete from hits where created_at < '#{1.week.ago.strftime("%Y-%m-%d %H:%M:%S")}'")
  end
    
  private
  
    def self.query(str)
      connection.select_all(str)
    end
      
    def self.zero_buffer(params)
      strftime = sanitize_sql_array(["%s", params[:strftime]])
      a = params[:start_time]
      b = params[:end_time]
      hits = []
      hits << "select '#{a.strftime(strftime)}' as created_at, 0 as hits, 0 as visits, 0 as visitors" while (a += eval("1.#{params[:period]}")) < b
      return hits * " union "
    end
end
