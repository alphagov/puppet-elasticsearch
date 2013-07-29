require 'spec_helper_system'

describe 'basic tests' do
  it 'class should work without errors' do
    pp = <<-EOS
      ensure_packages(['python-pip'])
      class { 'elasticsearch': require => Package['python-pip'] }
    EOS

    puppet_apply(pp) do |r|
      r.exit_code.should == 2
    end
  end
end
