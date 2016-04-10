require 'sinatra/base'
require 'continuation'

class ContinuationStore
  def initialize
    @store = {}
  end

  def obtain
    key = SecureRandom.hex
    callcc do |c|
      @store[key] = c
      key
    end
  end

  def [](key)
    @store[key]
  end
end

class App < Sinatra::Base
  set :store, ContinuationStore.new
  set :server, ["webrick"]
  # Continuations in Ruby can't be invoked across threads, so
  # we force WEBrick because it's single-threaded.

  def render_view(template, locals)
    page = erb template, locals: locals
    settings.renderer.call page
  end

  def read_first_number
    k = settings.store.obtain
    if k.respond_to?(:key)
      k["first"].to_i
    else
      render_view :first_number, {cont_id: k}
    end
  end

  def read_second_number(first)
    k = settings.store.obtain
    if k.respond_to?(:key)
      k["second"].to_i
    else
      render_view :second_number, {first: first, cont_id: k}
    end
  end

  def display_result_page(first, second, sum)
    render_view :result_page, {first: first, second: second, sum: sum}
  end

  def application
    x = read_first_number
    y = read_second_number x
    z = x + y
    display_result_page x, y, z
  end

  def application_wrapper
    callcc do |renderer|
      settings.set :renderer, renderer
      application
    end
  end

  get '/' do
    application_wrapper
  end

  post '/:id' do |id|
    callcc do |renderer|
      settings.set :renderer, renderer
      settings.store[id].call params
    end
  end

  run!
end
