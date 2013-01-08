module FontAssets
  class MimeTypes
    DEFAULT_TYPE = 'application/octet-stream'
    MIME_TYPES = {
      '.eot' => 'application/vnd.ms-fontobject',
      '.svg' => 'image/svg+xml',
      '.ttf' => 'application/x-font-ttf',
      '.otf' => 'application/x-font-otf',
      '.woff' => 'application/x-font-woff'
    }

    def initialize(types, default = DEFAULT_TYPE.dup)
      @types = types.dup
      @default = default

      MIME_TYPES.each_pair do |extension, type|
        set extension, type
      end
    end

    def [](extension)
      @types.fetch(extension, DEFAULT_TYPE.dup).dup
    end

    def font?(extension)
      MIME_TYPES.keys.include? extension
    end

    def set(extension, mime_type)
      if @types[extension].nil? || @types[extension] == @default
        set!(extension, mime_type)
      end
    end

    def set!(extension, mime_type)
      @types[extension] = mime_type
    end
  end
end
