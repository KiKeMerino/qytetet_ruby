#encoding: utf-8

require_relative "casilla"

module ModeloQytetet
  class Calle < Casilla
    
    def initialize(numCasilla,titulo)
      tipo=TipoCasilla::CALLE
      super(numCasilla,tipo)
      @titulo=titulo
      @coste=titulo.precioCompra
    end
    
    def asignarPropietario(jugador)
      @titulo.propietario = jugador
      @titulo
    end
    
    def pagarAlquiler
      costeAlquiler = @titulo.pagarAlquiler
    end
    
    def propietarioEncarcelado
      @titulo.propietarioEncarcelado
    end
    
    def tengoPropietario
      @titulo.tengoPropietario
    end
    
    def to_s
      devolver = super
      devolver= devolver + "\nCoste: #{@coste} \n#{@titulo.to_s}"
      devolver
    end
    
  end
end
