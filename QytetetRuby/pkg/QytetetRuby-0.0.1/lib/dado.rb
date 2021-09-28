#encoding: utf-8
require "singleton"
module ModeloQytetet
class Dado
  include Singleton
  
  
  attr_reader  :valor
  
  def initialize()
    @valor 
  end
 
  def tirar
    numero=Random.rand(1..6)   
    @valor=numero
  end
  
 
    def to_s
      "\nDado: #{@valor}"
    end
  end
end
