function init --on-event init_bundler
  set -l execs annotate      \
               cap           \
               capify        \
               cucumber      \
               dashing       \
               foreman       \
               guard         \
               kitchen       \
               middleman     \
               nanoc         \
               puma          \
               rackup        \
               rainbows      \
               rake          \
               rspec         \
               rubocop       \
               ruby          \
               shotgun       \
               sidekiq       \
               spec          \
               spinach       \
               spork         \
               thin          \
               thor          \
               unicorn       \
               unicorn_rails

  if set -q bundler_plugin_execs
    set execs $execs $bundler_plugin_execs
  end

  # Fish 2.1.1+ has support for --inherit-variable
  set -l do_eval (echo $FISH_VERSION | grep 2.1.1-)

  for executable in $execs
    if test -z "$do_eval"
      eval "function $executable; __execute_as_bundler $executable \$argv; end"
    else
      function $executable --inherit-variable executable
        __execute_as_bundler $executable $argv
      end
    end
  end

  function __execute_as_bundler
    if __is_a_bundled_executable $argv[1]
      command bundle exec $argv
    else
      eval command $argv
    end
  end

  function __is_a_bundled_executable
    if available bundle
      set -l bindir (command bundle exec ruby -e "puts Gem.bindir")
      test -f "$bindir/$argv"
    else
      return 1
    end
  end
end
