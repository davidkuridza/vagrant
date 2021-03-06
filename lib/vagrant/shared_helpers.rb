require "pathname"

module Vagrant
  # This is the default endpoint of the Vagrant Cloud in
  # use. API calls will be made to this for various functions
  # of Vagrant that may require remote access.
  #
  # @return [String]
  DEFAULT_SERVER_URL = "https://vagrantcloud.com"

  # This returns a true/false showing whether we're running from the
  # environment setup by the Vagrant installers.
  #
  # @return [Boolean]
  def self.in_installer?
    !!ENV["VAGRANT_INSTALLER_ENV"]
  end

  # Returns the path to the embedded directory of the Vagrant installer,
  # if there is one (if we're running in an installer).
  #
  # @return [String]
  def self.installer_embedded_dir
    return nil if !Vagrant.in_installer?
    ENV["VAGRANT_INSTALLER_EMBEDDED_DIR"]
  end

  # This returns whether or not 3rd party plugins should be loaded.
  #
  # @return [Boolean]
  def self.plugins_enabled?
    !ENV["VAGRANT_NO_PLUGINS"]
  end

  # Returns the URL prefix to the server.
  #
  # @return [String]
  def self.server_url
    result = ENV["VAGRANT_SERVER_URL"]
    result = nil if result == ""
    result || DEFAULT_SERVER_URL
  end

  # The source root is the path to the root directory of the Vagrant source.
  #
  # @return [Pathname]
  def self.source_root
    @source_root ||= Pathname.new(File.expand_path('../../../', __FILE__))
  end

  # This returns the path to the ~/.vagrant.d folder where Vagrant's
  # per-user state is stored.
  #
  # @return [Pathname]
  def self.user_data_path
    # Use user spcified env var if available
    path = ENV["VAGRANT_HOME"]

    # On Windows, we default ot the USERPROFILE directory if it
    # is available. This is more compatible with Cygwin and sharing
    # the home directory across shells.
    if !path && ENV["USERPROFILE"]
      path = "#{ENV["USERPROFILE"]}/.vagrant.d"
    end

    # Fallback to the default
    path ||= "~/.vagrant.d"

    Pathname.new(path).expand_path
  end
end
