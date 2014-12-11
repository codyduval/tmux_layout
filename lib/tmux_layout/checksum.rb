module TmuxLayout
  class CheckSum
    attr_accessor :config_string

    def initialize(config_string)
      @config_string = config_string
    end

    def csum
      csum = 0
      @config_string.each_char do |character|
        character = character.ord
        csum = (csum >> 1) + ((csum & 1) << 15);
        csum += character 
      end
      csum.to_s(16)
    end
  end

end
