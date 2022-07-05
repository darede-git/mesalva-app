# frozen_string_literal: true

module GeneratorHelper
  def args_to_formatted_string
    @args.join(' ') if args?
  end

  def args_to_symbols
    new_args = []
    args.each do |arg|
      new_args << ":#{arg.split(':').first}"
    end
    new_args.to_s.gsub!('[', '').gsub!(']', '').gsub!('"', '')
  end

  def references_format(index)
    set_index(index)
    new_args = []
    args.each do |arg|
      new_args << ":#{arg.split(':').first}" if arg.split(':').second.to_s.eql?('references')
    end
    new_args[@index].to_s.gsub(':', '')
  end

  def references_count
    references_quantity = 0
    args.each do |arg|
      references_quantity += 1 if arg.split(':').second.to_s.eql?('references')
    end
    references_quantity
  end

  def references?
    references_count.positive?
  end

  def namespace_folder(entity)    
    "#{entity.split("::").first.to_s.downcase}/" if entity.include?("::")
  end

  def line_break_for_loop(loop_count, index)
    set_index(index)
    "\n" unless loop_count == (@index + 1)
  end

  def args_count
    args.count
  end

  def arg_content(index)
    set_index(index)
    return string_for_factory if string_type?

    return integer_for_factory if integer_type?

    return datetime_for_factory if datetime_type?

    association_for_factory if reference_type?
  end

  def custom_file(path, file_name)
    file = Dir["#{path}#{Time.now.getutc.year}#{Time.now.getutc.month.to_s.rjust(2, '0')}*_#{file_name}.rb"].first
    return unless File.exist?(file) && File.extname(file) == '.rb'

    File.open(file, 'r') do |f|
      body = f.read
      File.open(file, 'w') do |new_f|
        new_f.write("# frozen_string_literal: true\n\n#{body}")
      end
    end
  end

  def controller_command_name
    "#{namespace_folder(controller_class_name)}#{file_name}"
  end

  def controller_command_with_args
    "#{controller_command_name} #{args_to_formatted_string}"
  end

  private

  def set_index(index)
    @index = index
  end

  def args?
    args_count.positive?
  end

  def type
    args[@index].split(":").second
  end

  def string_type?
    %w[string text].include?(type)
  end

  def integer_type?
    type.eql?('integer')
  end

  def datetime_type?
    type.eql?('datetime')
  end

  def reference_type?
    type.eql?('references')
  end

  def string_for_factory
    "#{args_list} 'my_string'"
  end

  def integer_for_factory
    "#{args_list} 1"
  end

  def datetime_for_factory
    "#{args_list} '#{Time.now}'"
  end

  def association_for_factory
    "association :#{args[@index].split(':').first}, factory: :#{args[@index].split(':').first}"
  end

  def args_list
    new_args = []
    args.each do |arg|
      new_args << arg.split(':').first.to_s
    end
    new_args[@index].to_s.gsub(':', '')
  end
end
