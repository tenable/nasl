################################################################################
# Copyright (c) 2011-2014, Tenable Network Security
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

class TestComment < Test::Unit::TestCase
  include Nasl::Test

  def test_standalone
    tree = parse(
      <<-EOF
      # Standalone
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Standalone", comm.text.body)
    assert_nil(comm.next)
  end

  def test_unattached
    tree = parse(
      <<-EOF
      # Unattached
      ;
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Unattached", comm.text.body)
    assert_nil(comm.next)

    tree = parse(
      <<-EOF
      # Unattached
      global_var foo;
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Unattached", comm.text.body)
    assert_nil(comm.next)
  end

  def test_export
    tree = parse(
      <<-EOF
      foo = TRUE;

      # Export
      export function foo() {}
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Export", comm.text.body)
    assert_equal(Nasl::Export, comm.next.class)
  end

  def test_function
    tree = parse(
      <<-EOF
      foo = TRUE;

      # Function
      function foo() {}
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Function", comm.text.body)
    assert_equal(Nasl::Function, comm.next.class)
  end

  def test_global
    tree = parse(
      <<-EOF
      foo = TRUE;

      # Global
      global_var bar;
      EOF
    )
    assert_not_nil(tree)

    comms = tree.all(:Comment)
    assert_not_nil(comms)
    assert_equal(1, comms.length)

    comm = comms.first
    assert_equal("# Global", comm.text.body)
    assert_equal(Nasl::Global, comm.next.class)
  end
end
