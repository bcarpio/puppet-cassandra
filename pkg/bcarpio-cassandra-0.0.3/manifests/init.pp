# /etc/puppet/modules/cassandra/manifests/init.pp

class cassandra {

        require cassandra::params       
    	
        group { "cassandra":
		ensure => present,
		gid => "900",
	}

	user { "cassandra":
		ensure => present,
		comment => "Cassandra",
		password => "!!",
		uid => "900",
		gid => "900",
		shell => "/bin/bash",
		home => "/home/cassandra",
		require => Group["cassandra"],
	}
	
	file { "/home/cassandra/.bash_profile":
		ensure => present,
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-bash_profile",
		content => template("cassandra/home/bash_profile.erb"),
		require => User["cassandra"]
	}
		
	file { "/home/cassandra":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-home",
		require => [ User["cassandra"], Group["cassandra"] ],
	}
	
        file {"$cassandra::params::cassandra_base":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-base",
	}
        
        file {"$cassandra::params::cassandra_log_path":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-log-path",
        require => File["cassandra-base"]
	}
	
        file {"$cassandra::params::data_path":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-data-path",
	}
        
        file {"$cassandra::params::commitlog_directory":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-commitlog-directory",
        require => File["cassandra-base"]
	}
        
        file {"$cassandra::params::saved_caches":
		ensure => "directory",
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-saved-caches",
        require => File["cassandra-base"]
	}
        
        file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}-bin.tar.gz":
		mode => 0644,
		owner => cassandra,
		group => cassandra,
		source => "puppet:///modules/cassandra/apache-cassandra-${cassandra::params::version}-bin.tar.gz",
		alias => "cassandra-source-tgz",
		before => Exec["untar-cassandra"],
		require => File["cassandra-base"]
	}
        
        exec { "untar apache-cassandra-${cassandra::params::version}-bin.tar.gz":
		command => "tar -zxf apache-cassandra-${cassandra::params::version}-bin.tar.gz",
		cwd => "${cassandra::params::cassandra_base}",
		creates => "${cassandra::params::cassandra_base}/cassandra-${cassandra::params::version}",
		alias => "untar-cassandra",
		refreshonly => true,
		subscribe => File["cassandra-source-tgz"],
		user => "cassandra",
		before => [ File["cassandra-symlink"], File["cassandra-app-dir"]]
	}
        
        file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}":
		ensure => "directory",
		mode => 0644,
		owner => "cassandra",
		group => "cassandra",
		alias => "cassandra-app-dir",
                before => [ File["cassandra-yaml"], File["cassandra-log4j"], File["cassandra-env"] ]
	}
		
	file { "${cassandra::params::cassandra_base}/apache-cassandra":
		force => true,
		ensure => "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}",
		alias => "cassandra-symlink",
		owner => "cassandra",
		group => "cassandra",
		require => File["cassandra-source-tgz"],
	}
        
        file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/cassandra.yaml":
                alias => "cassandra-yaml",
                content => template("cassandra/conf/cassandra.yaml.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }
        
        file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/cassandra-env.sh":
                alias => "cassandra-env",
                content => template("cassandra/conf/cassandra-env.sh.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }
        
        file { "${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/conf/log4j-server.properties":
                alias => "cassandra-log4j",
                content => template("cassandra/conf/log4j-server.properties.erb"),
                owner => "cassandra",
                group => "cassandra",
                mode => "644",
                require => File["cassandra-app-dir"]
        }
	file {"${cassandra::params::cassandra_base}/apache-cassandra-${cassandra::params::version}/lib/mx4j-tools.jar":
		ensure => present,
		source => "puppet:///modules/cassandra/mx4j-tools.jar",
		owner => "cassandra",
		group => "cassandra",
		mode => "644",
	}

}
