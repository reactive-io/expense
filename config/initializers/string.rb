class String
  def to_d
    BigDecimal.new(self)
  end

  def to_tsquery(strict = true)
    return '' if self.blank?

    self.
    strip.                                     # remove leading and tailing whitespace
    downcase.                                  # make all lowercase
    gsub(/[^[:alnum:]\-\s]/, '').              # remove all non-alphanumberic and non-space characters
    gsub('-', ' ').                            # replace all dashes with spaces
    gsub(/\s+/, ' ').                          # replace multiple spaces with just one space
    strip.                                     # strip away leading and trailing spaces
    gsub(/[\s]/, ":* #{strict ? '&' : '|'} "). # convert spaces into prefix matchers
    gsub(/(.)$/, '\\1:*')                      # make the last token a prefix matcher as well
  end

  def to_slug
    self.
    downcase.                  # make all lowercase
    gsub(/'/, "").             # remove contractions
    gsub(/[^[:alnum:]]/, "_"). # remove non-alpha-numeric characters
    gsub(/_{2,}/, "_").        # remove duplicate underscores
    gsub(/^_|_$/, "")          # remove heading and tailing underscores
  end
end
