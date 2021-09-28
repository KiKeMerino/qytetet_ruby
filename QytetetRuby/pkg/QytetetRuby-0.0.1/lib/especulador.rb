#encoding: utf-8
require_relative "jugador"
module ModeloQytetet
  class Especulador < Jugador
    
    def initialize(unJugador,fianza)
      super(unJugador.nombre, unJugador.encarcelado, unJugador.saldo, unJugador.propiedades,unJugador.cartaLibertad,unJugador.casillaActual)
      @fianza=fianza
    end
    
    def pagarImpuesto
      @saldo=@saldo-Integer((@cartaActual.coste/2))
    end
    
    def convetirme (fianza)
      @fianza=fianza
      self
    end
    
    def deboIrACarcel
      debo=false
      deboSuper= super
      if deboSuper and !pagarFianza
        debo=true
      end
      debo
    end
    
    def pagarFianza
      puedo=false
      if @saldo>@fianza
        puedo=true
        @saldo-=@fianza
      end
      puedo
    end
    
    def puedoEdificarCasa(titulo)
      puedo=false
      numCasas = titulo.numCasas
      if numCasas < 8
        costeEdificarCasa = titulo.precioEdificar
        tengo_saldo = tengoSaldo(costeEdificarCasa)
        if tengo_saldo==true
          puedo=true
        end
      end
      puedo
    end
    
    def puedoEdificarHotel(titulo)
      puedo=false
      numCasas=titulo.numCasas
      if numCasas>=4
        costeEdificarHotel=titulo.precioEdificar
        tengoSaldo=tengoSaldo(costeEdificarHotel)
        if tengoSaldo==true
          puedo=true
        end
      end
      puedo
    end
    
    def to_s
      devolver= super
      devolver = devolver + "\nFianza: #{@fianza}"
      devolver
    end
    
    protected
      :pagarImpuesto
      :Initialize
      :convertirme
      :deboIrACarcel
      :puedoEdificarCasa
      :puedoEdificarHotel
      
    private
      :pagarFianza
      
  end
end
