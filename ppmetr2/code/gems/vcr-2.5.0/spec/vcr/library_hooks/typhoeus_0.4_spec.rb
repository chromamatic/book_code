#---
# Excerpted from "Metaprogramming Ruby 2",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/ppmetr2 for more book information.
#---
require 'spec_helper'

describe "Typhoeus 0.4 hook", :with_monkey_patches => :typhoeus_0_4 do
  after(:each) do
    ::Typhoeus::Hydra.clear_stubs
  end

  def disable_real_connections
    ::Typhoeus::Hydra.allow_net_connect = false
    ::Typhoeus::Hydra::NetConnectNotAllowedError
  end

  def enable_real_connections
    ::Typhoeus::Hydra.allow_net_connect = true
  end

  def directly_stub_request(method, url, response_body)
    response = ::Typhoeus::Response.new(:code => 200, :body => response_body)
    ::Typhoeus::Hydra.stub(method, url).and_return(response)
  end

  it_behaves_like 'a hook into an HTTP library', :typhoeus, 'typhoeus 0.4'

  describe "VCR.configuration.after_library_hooks_loaded hook" do
    it 'disables the webmock typhoeus adapter so it does not conflict with our typhoeus hook' do
      ::WebMock::HttpLibAdapters::TyphoeusAdapter.should_receive(:disable!)
      $typhoeus_after_loaded_hook.conditionally_invoke
    end

    it "warns about Typhoeus 0.4 deprecation" do
      ::Kernel.should_receive(:warn).with("WARNING: VCR's Typhoeus 0.4 integration is deprecated and will be removed in VCR 3.0.")
      $typhoeus_0_4_after_loaded_hook.conditionally_invoke
    end
  end
end if RUBY_INTERPRETER == :mri && ::Typhoeus::VERSION.to_f < 0.5

