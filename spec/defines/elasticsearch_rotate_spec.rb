require 'spec_helper'

describe 'elasticsearch::rotate', :type => :define do
  let(:title) { 'dosey-doe' }
  let(:params) {{}}

  context "ensure present" do
    context "default" do
      it do
        should contain_cron('dosey-doe-cron').
          with_ensure('present').
          with_command('/usr/local/bin/es-rotate --delete-old --delete-maxage 21 --optimize-old --optimize-maxage 1 logs')
      end
    end

    context "no delete" do
      let(:params) {{
        :delete_old => 'false',
      }}
      it do
        should contain_cron('dosey-doe-cron').
          with_ensure('present').
          with_command('/usr/local/bin/es-rotate --optimize-old --optimize-maxage 1 logs')
      end
    end
  end

  context "ensure absent" do
    let(:params) {{
      :ensure => 'absent',
    }}
    it do
      should contain_cron('dosey-doe-cron').
        with_ensure('absent')
    end
  end
end
