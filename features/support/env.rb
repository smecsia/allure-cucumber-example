begin
  require 'rspec/expectations';
rescue LoadError;
  require 'spec/expectations';
end
require 'selenium-webdriver'
require 'allure-cucumber'
require_relative 'docker_util'

Allure.configure do |c|
  c.results_directory = "build/allure-results"
end

Before do |scenario|

  browser = ENV['browser'] || 'firefox'
  docker_image = ENV['docker_image'] || 'selenium/standalone-firefox:3'
  port_number = ENV['port_number'] || '4444'

  @container = start_container(docker_image, port_number)
  host_addr = @container.host_addr
  host_port = @container.host_port
  url = "http://#{host_addr}:#{host_port}/wd/hub/"

  Allure.parameter("browser", browser)
  Allure.parameter("docker_image", docker_image)
  Allure.parameter("url", url)

  @browser = Selenium::WebDriver.for :remote, url: url, desired_capabilities: browser.to_sym
end

After do |scenario|
  if scenario.failed?
    Dir.mktmpdir {|dir|
      screenshot_path = "#{dir}/#{Time.now.strftime("failshot__%d_%m_%Y__%H_%M_%S")}.png"
      @browser.save_screenshot screenshot_path
      Allure.add_attachment(name: "screenshot", source: File.open(screenshot_path), type: Allure::ContentType::PNG, test_case: true)
    }
  end
  @container.remove
end