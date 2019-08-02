require 'docker'

# Checks if running in container and returns container id. Returns nil otherwise
# @return [String]
def current_container_id
  cgroup_content = File.read("/proc/1/cgroup")
  @running_in_container = cgroup_content.include? "docker/"
  if @running_in_container
    cgroup_content.split.each { |line|
      if line.include? "docker/" or line.include? "kubepods/"
        parts = line.split(":")
        res_parts = parts[2].split("/")
        return res_parts[-1][0..12]
      end
    }
  end
  nil
end


# Represents Docker container data
class Container
  attr_accessor :host_port
  attr_accessor :host_addr

  def initialize(container, exposed_port)
    @container = container
    @host_port = @container.json["NetworkSettings"]["Ports"]["#{exposed_port}/tcp"][0]["HostPort"]
    cid = current_container_id
    @host_addr = (cid == nil ? Socket.gethostname : Docker::Container.get(cid).json["NetworkSettings"]["Gateway"])
  end

  # Stops and removes started container
  def remove
    @container.stop
    @container.delete
  end
end

# Creates and starts container exposing specific port
# @return [Container]
def start_container(image, expose_port)
  container = Docker::Container.create('Image' => image, 'HostConfig' => {'PortBindings' => {"#{expose_port}/tcp" => [{}]}})
  container.start
  Container.new(container, expose_port)
end

