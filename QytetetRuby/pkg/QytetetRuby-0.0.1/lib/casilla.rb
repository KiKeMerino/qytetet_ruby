#encoding: utf-8
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
module ModeloQytetet
  class Casilla
    
    attr_reader :numeroCasilla, :coste, :tipo
    attr_accessor :titulo
    
    def initialize( num_casilla, type)
      @numeroCasilla=num_casilla
      @tipo=type
      @coste = 0
    end
        
    def soyEdificable
      
      tipoCalle=false
      if @tipo==TipoCasilla::CALLE
        tipoCalle=true
      end
      tipoCalle
      
    end
    
    
    def to_s
      "\nCASILLA:
      Numero: #{@numeroCasilla}
      Tipo: #{@tipo} \n"
    end
  
    protected
      :soyEdificable
  end
end
