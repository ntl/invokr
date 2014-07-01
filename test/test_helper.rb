$LOAD_PATH.<< File.expand_path '../../lib', __FILE__
require 'invokr'

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module TestMethodBank
  extend self

  def required_argument album
    album
  end

  def optional_argument album = 'junta'
    album
  end

  def double_optional_argument album1 = 'junta', album2 = 'rift'
  end

  def block_argument &album_block
    album_block.call
  end

  def multiple_required_arguments album, guitarist
    [album, guitarist]
  end

  def one_required_one_optional_argument album, guitarist = 'trey'
    [album, guitarist]
  end

  def splat_argument album = 'junta', *rest
    [album, *rest]
  end

  def just_yields
    yield
  end

  def inspect
    "#<#{name}:0xdeadbeef>"
  end

  if RUBY_VERSION >= '2.0'
    module_eval <<-RB, __FILE__, __LINE__
      def optional_keyword_argument album: 'pitcher_of_nectar'
        album
      end

      def keyword_splat_argument album: 'pitcher_of_nectar', **rest
        [album, **rest]
      end
    RB
  end

  if RUBY_VERSION >= '2.1'
    module_eval <<-RB, __FILE__, __LINE__
      def required_keyword_argument(album:)
        album
      end
    RB
  end
end
