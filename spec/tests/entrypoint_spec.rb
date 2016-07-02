require "serverspec"
require "docker"

set :backend, :docker

describe "Dockerfile" do
  before(:all) do
    @container = Docker::Container.create(
      :Image => ENV['DOCKER_IMAGE_NAME'] + ':' + ENV['DOCKER_IMAGE_TAG'],
      :Tty => true,
      :Cmd => 'bash',
      :HostConfig => {
        :Binds => [
          Dir.pwd + '/spec/rsc/docker-init.sh:/usr/local/bin/docker-init'
        ]
      }
    )
    @container.start
    set :docker_container, @container.id
  end

  describe file('/var/log/docker-init.log') do
    its(:content) { should match "docker-init test" }
  end

  after(:all) do
    if !@container.nil?
      @container.delete(:force => true)
    end
  end
end
