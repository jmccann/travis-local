require 'yaml'
require 'open4'

#
# Run travis test suites locally
#
class TravisLocal

  #
  # Initaialize TravisLocal by reading config file
  #
  def initialize
    @path = Dir.pwd
    fail 'No .travis.yml file found' unless File.exist? "#{@path}/.travis.yml"
    @config = YAML.load(File.read "#{@path}/.travis.yml")
    @passed = true
  end

  #
  # Run everything needed to test
  #
  def test
    install_gems
    run_before_scripts
    run_scripts

    fail 'Some tests failed!' unless @passed

    puts 'All tests passed!'
  end

  #
  # Install gems if Gemfile exists
  #
  def install_gems
    return unless File.exist? "#{@path}/Gemfile"
    puts 'INFO: Installing gems'
    run 'bundle install --jobs=3 --retry=3'
  end

  #
  # Run 'before_scripts' to prep for tests
  #
  def run_before_scripts
    return if @config['before_script'].empty?

    puts 'INFO: Running pre test scripts'
    @config['before_script'].each do |cmd|
      run cmd
    end
  end

  #
  # Run 'scripts' for tests
  #
  def run_scripts
    @config['script'].each do |cmd|
      puts "TEST: #{cmd}"
      status = run cmd

      # Failure
      unless status.to_i == 0
        @passed = false
        puts "ERROR: '#{cmd}' failed with #{status}"
        next
      end

      puts "PASSED: #{cmd}"
    end
  end

  private

  #
  # Run system commands with realtime output
  #
  # @param [String] the system command to run
  #
  # @return [Process::Status] the exit status information
  #
  def run(cmd)
    Open4.popen4(cmd) do |_pid, _stdin, stdout, _stderr|
      stdout.each { |line| print line }
    end
  end
end
