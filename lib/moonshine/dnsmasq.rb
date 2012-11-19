module Moonshine
  module Dnsmasq
  
    def self.included(manifest)
      manifest.class_eval do 
        extend ClassMethods
      end
    end
  
    module ClassMethods
            
      def dnsmasq(options = {})
        configure(:dnsmasq => {})
        cache_size = configuration[:dnsmasq][:cache_size] || 256
        
        package 'dnsmasq',
          :ensure => :installed
          
        file '/etc/dnsmasq.conf',
          :ensure => :present,
          :owner => 'root',
          :mode => '744',
          :require => package('dnsmasq'),
          :notify => service('dnsmasq'),
          :content => template(File.join(File.dirname(__FILE__),'templates','dnsmasq.conf.erb'), binding)
        
        service 'dnsmasq',
          :require => package('dnsmasq'),
          :restart => '/etc/init.d/dnsmasq restart',
          :ensure => :running
        
      end
      
    end
  
  end
end