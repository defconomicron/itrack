class Hit < ActiveRecord::Base
  def self.traffic(params)  
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time  => params[:start_time])
    conditions2.merge!(:end_time    => params[:end_time])
    conditions2.merge!(:domain      => params[:domain]) if params[:domain]
    conditions2.merge!(:page        => params[:page]) if params[:page]
    conditions2.merge!(:country     => params[:country]) if params[:country]
    conditions2.merge!(:region      => params[:region]) if params[:region]
    conditions2.merge!(:city        => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        strftime('#{params[:strftime]}', created_at) as created_at,
        sum(hits) as hits,
        sum(visitors) as visitors,
        sum(visits) as visits
      from (
        select
          strftime('#{params[:strftime]}', created_at) as created_at,
          count(id) as hits,
          count(new_visitor) as visitors,
          count(new_visit) as visits
        from hits
        where #{sqa}
        group by strftime('#{params[:strftime]}', created_at)
        
        union
        
        #{zero_buffer(params)}
      )
      group by strftime('#{params[:strftime]}', created_at)
      order by strftime('#{params[:strftime]}', created_at)
    ")
  end
  
  def self.http_accept_languages(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:page => params[:page]) if params[:page]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        http_accept_language,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by http_accept_language
      order by hits desc
    ")
  end
  
  def self.http_user_agents(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time => params[:end_time])
    conditions2.merge!(:domain => params[:domain]) if params[:domain]
    conditions2.merge!(:page => params[:page]) if params[:page]
    conditions2.merge!(:country => params[:country]) if params[:country]
    conditions2.merge!(:region => params[:region]) if params[:region]
    conditions2.merge!(:city => params[:city]) if params[:city]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])

    query("
      select
        http_user_agent,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by http_user_agent
      order by hits desc
    ")
  end
  
  def self.domains(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "city = :city" if params[:city]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]
    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time   => params[:end_time])
    conditions2.merge!(:page       => params[:page]) if params[:page]
    conditions2.merge!(:country    => params[:country]) if params[:country]
    conditions2.merge!(:region     => params[:region]) if params[:region]
    conditions2.merge!(:city       => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        domain,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by domain
      order by hits desc
    ")
  end
  
  def self.pages(params)
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
    conditions2.merge!(:start_time  => params[:start_time])
    conditions2.merge!(:end_time    => params[:end_time])
    conditions2.merge!(:domain      => params[:domain]) if params[:domain]
    conditions2.merge!(:country     => params[:country]) if params[:country]
    conditions2.merge!(:region      => params[:region]) if params[:region]
    conditions2.merge!(:city        => params[:city]) if params[:city]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        page,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by page
      order by hits desc
    ")
  end
    
  def self.countries(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time   => params[:end_time])
    conditions2.merge!(:domain     => params[:domain]) if params[:domain]
    conditions2.merge!(:page       => params[:page]) if params[:page]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]
 
    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        country,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by country
      order by hits desc
    ")
  end

  def self.regions(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"    
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time   => params[:end_time])
    conditions2.merge!(:domain     => params[:domain]) if params[:domain]
    conditions2.merge!(:page       => params[:page]) if params[:page]
    conditions2.merge!(:country    => params[:country]) if params[:country]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        region,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by region
      order by hits desc
    ")
  end

  def self.cities(params)
    conditions1 = []
    conditions1 << "created_at >= :start_time"    
    conditions1 << "created_at <= :end_time"    
    conditions1 << "domain = :domain" if params[:domain]
    conditions1 << "page = :page" if params[:page]
    conditions1 << "country = :country" if params[:country]
    conditions1 << "region = :region" if params[:region]
    conditions1 << "http_user_agent = :http_user_agent" if params[:http_user_agent]
    conditions1 << "http_accept_language = :http_accept_language" if params[:http_accept_language]

    conditions1 = conditions1.join(" and ")
    
    conditions2 = {}
    conditions2.merge!(:start_time => params[:start_time])
    conditions2.merge!(:end_time   => params[:end_time])
    conditions2.merge!(:domain     => params[:domain]) if params[:domain]
    conditions2.merge!(:page       => params[:page]) if params[:page]
    conditions2.merge!(:country    => params[:country]) if params[:country]
    conditions2.merge!(:region     => params[:region]) if params[:region]
    conditions2.merge!(:http_user_agent => params[:http_user_agent]) if params[:http_user_agent]
    conditions2.merge!(:http_accept_language   => params[:http_accept_language]) if params[:http_accept_language]

    sqa = sanitize_sql_array([ conditions1, conditions2 ])
    
    query("
      select
        city,
        count(id) as hits,
        count(new_visitor) as visitors,
        count(new_visit) as visits
      from hits
      where #{sqa}
      group by city
      order by hits desc
    ")
  end

  def self.clean
    query("delete from hits where created_at < '#{1.week.ago.strftime("%Y-%m-%d %H:%M:%S")}'")
  end
    
  private
  
    def self.query(str)
      connection.select_all(str)
    end
      
    def self.zero_buffer(params)
      a = params[:start_time]
      b = params[:end_time]
      hits = []
      hits << "select '#{a.strftime(params[:strftime])}' as created_at, 0 as hits, 0 as visits, 0 as visitors" while (a += eval("1.#{params[:period]}")) < b
      return hits * " union "
    end
end
