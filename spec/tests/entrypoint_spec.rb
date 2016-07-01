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
          Dir.pwd + '/spec/rsc/entrypoint.sh:/docker_entrypoint.sh'
        ]
      }
    )
    @container.start
    set :docker_container, @container.id
  end

  describe file('/tmp/entrypoint-test') do
    its(:content) { should eq "ok\n" }
  end

  after(:all) do
    if !@container.nil?
      @container.delete(:force => true)
    end
  end
end
