Installation
============

Git
---

Installing the source from Git is done as follows:

    git clone git://github.com/tenable/nasl.git

Gem
---

Installing the package from RubyGems is done as follows:

    gem install nasl

Usage
=====

Standalone
----------

To avoid conflicting with the NASL interpreter, the NASL gem's binary is
installed as <nasl-parse>. As an application, it has very few actions that it
can perform.

# Benchmark: This benchmarks the time taken to parse the input path(s) over a
  number of iterations. The number of iterations can be adjusted by the <-i>
  switch.

    % nasl-parse -i 10 benchmark /opt/nessus/lib/nessus/plugins/ssl_certificate_chain.nasl
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------
    Rehearsal --------------------------------------------
    Tokenize   1.687500   0.000000   1.687500 (  1.688397)
    Parse      1.835938   0.015625   1.851562 (  1.857094)
    ----------------------------------- total: 3.539062sec

                   user     system      total        real
    Tokenize   1.304688   0.015625   1.320312 (  1.319951)
    Parse      1.046875   0.000000   1.046875 (  1.046957)
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------

# Parse: This parses the input path(s) and indicates whether the parse was
  successful.

    % nasl-parse parse /opt/nessus/lib/nessus/plugins/ssl_certificate_chain.nasl
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------
    Successfully parsed the contents of the file.
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------

# Test: This runs unit tests distributed with the application. Specific unit
  tests can be specified on the command line, otherwise all tests will be run.

    % nasl-parse test
    Run options:
    
    # Running tests:
    
    .............................................................................
    
    Finished tests in 11.773983s, 6.5398 tests/s, 33493.8487 assertions/s.
    
    77 tests, 394356 assertions, 0 failures, 0 errors, 0 skips

# Tokenize: This tokenizes the input path(s) and prints the token/byte-range
  pairs to stdout.

    % nasl-parse tokenize /opt/nessus/lib/nessus/plugins/ssl_certificate_chain.nasl
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------
    [COMMENT,              0...1076]
    [IF,                1076...1079]
    [LPAREN,            1079...1080]
    [IDENT,             1080...1091]
    [CMP_LT,            1091...1093]
    ...
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------

# XML: This parses the input path(s), and then prints an XML representation of
  the parse tree to stdout.

    % nasl-parse xml /opt/nessus/lib/nessus/plugins/ssl_certificate_chain.nasl
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------
    <tree>
      <if>
        <expression>
          <op>&lt;</op>
          <lvalue>
    ...
    -------------------------[ ssl_certificate_chain.nasl ]-------------------------

Library
-------

The primary users of this gem are [Pedant][pedant] and [Nasldoc][nasldoc]. Other
uses are encouraged, of course! The <Parser> class is the most useful part,
obviously, and can be used as follows:

    require 'nasl'

    tree = Nasl::Parser.new.parse(file_contents, path_to_file)

That's all there is to it. If there are any errors, it'll throw an instance of
<ParseException> that will include as much context about the error as possible.

[nasldoc]: https://github.com/tenable/nasldoc
[pedant]: https://github.com/tenable/pedant
