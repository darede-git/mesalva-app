class CourseClassCreator

  WEEK_DAYS = {
    "1": "Segunda",
    "2": "Terça",
    "3": "Quarta",
    "4": "Quinta",
    "5": "Sexta",
    "6": "Sábado",
    "7": "Domingo"
  }

  def initialize(filename)
    @filename = filename
    @rows = CSV.read(open("https://mesalva-uploads.s3.amazonaws.com/data/courses/enem-e-vestibulares/#{filename}/sumula.csv"))

    @course_infos = @rows.slice!(0)
    @module_infos = @rows.slice!(0)
    @class_name = @course_infos.second
    @weeks = {}
    @mock_module = NodeModule.last
  end

  def create
    @rows.each do |row|
      module_id = row[0]
      week_number = row[1]
      day = row[2]
      starts_at = row[3].gsub(/:00$/, '')
      ends_at = row[4].gsub(/:00$/, '')

      if @weeks[week_number].nil?
        @weeks[week_number] = {days: {}, title: "Aulas e Exercícios - Semana ##{week_number}"}
      end

      if @weeks[week_number][:days][day].nil?
        @weeks[week_number][:days][day] = {
          title: day_title(day),
          children: []
        }
      end
      node_module = NodeModule.find(module_id)
      permalink = Permalink.where("slug LIKE 'enem-e-vestibulares/monitorias/salas-por-materia-%' AND item_id IS NULL AND node_module_id = ?", node_module.id).take

      @weeks[week_number][:days][day][:children] << {
        title: node_module.name,
        hour: "das #{starts_at} as #{ends_at}",
        href: "/#{permalink.slug}",
        icon: "https://cdn.mesalva.com/front-assets/icons/ic_check.svg"
      }
    end
    @weeks
  end

  def mount_navigation(days)
    days.keys.map do |str_date|
      date = Date.parse(str_date)
      day_name = WEEK_DAYS[date.cwday.to_s.to_sym]
      { day: date.day.to_s.rjust(2,'0'), weekDay: day_name[0..2] }
    end
  end

  def to_json
    @weeks.map do |week_number, content|
      navigation = mount_navigation(content[:days])
      children = content[:days].values
      filename = "#{week_number.rjust(3,'0')}"
      content = {
        title: content[:title],
        subtitle: '',
        navigation: navigation,
        children: children
      }.to_json
      options = {}
      options['file_path'] = "data/courses/enem-e-vestibulares/#{@class_name}/"
      MeSalva::Aws::File.write("#{filename}.json", content, options)
    end
  end

  def day_title(day)
    date = Date.parse(day)
    day_name = WEEK_DAYS[date.cwday.to_s.to_sym]
    "#{day_name} - #{day.gsub(/\/(\d{4})$/, '')}"
  end

  def debug
    @weeks
  end
end

# action = CourseClassCreator.new('turma-2022-1')
# action.create
# action.to_json
#
# action = CourseClassCreator.new('medicina-2022-1')
# action.create
# action.to_json
