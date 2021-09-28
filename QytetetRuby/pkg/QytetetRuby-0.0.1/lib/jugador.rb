#encoding: utf-8


require_relative "titulo_propiedad"
require_relative "sorpresa"
require_relative "casilla"

module ModeloQytetet
  class Jugador
    
    attr_accessor :encarcelado ,:propiedades, :nombre, :saldo, :cartaLibertad, :casillaActual
    
    def initialize(nombre,encarcelado,saldo,propiedades,cartaLibertad,casillaActual)
      @encarcelado = encarcelado
      @nombre=nombre
      @saldo = saldo
      @propiedades = propiedades
      @cartaLibertad = cartaLibertad
      @casillaActual =casillaActual
    end
    
    def self.nuevo(nombre)
      encarcelado=false
      saldo=7500
      propiedades=Array.new
      cartaLibertad=nil
      casillaActual=Casilla.new(0,TipoCasilla::SALIDA)
      new(nombre,encarcelado,saldo,propiedades,cartaLibertad,casillaActual)
    end
    def self.copia(jugador)
      new(jugador.nombre,jugador.encarcelado,jugador.saldo,jugador.propiedades,jugador.cartaLibertad,jugador.casillaActual)
    end
    
    def <=>(otroJugador)
      otroCapital= otroJugador.obtenerCapital
      miCapital=obtenerCapital
      if otroCapital>miCapital
        return 1 end
      if otroCapital<miCapital
        return -1 end
      return 0
    end
   
    def cancelarHipoteca(titulo)
      
      hipotecaCancelada=false
      coste=titulo.calcularCosteCancelar
      tengoSaldo=tengoSaldo(coste)
      if tengoSaldo==true
        modificarSaldo(-coste)
        titulo.cancelarHipoteca
        hipotecaCancelada=true
      end
      hipotecaCancelada
      
    end
    
    def comprarTituloPropiedad
      comprado = false
      costeCompra = @casillaActual.coste
      
      if costeCompra<@saldo 
        comprado = true
        titulo = @casillaActual.asignarPropietario(self)
        @propiedades << titulo
        modificarSaldo(-costeCompra)
      end
      comprado
    end
    
    def cuantasCasasHotelesTengo 
      total=0
      for i in @propiedades
        total=total+i.numCasas+i.numHoteles
      end
      total
    end
    
    def deboPagarAlquiler
      titulo = @casillaActual.titulo
      es_de_mi_propiedad = esDeMiPropiedad(titulo)
      
      if !es_de_mi_propiedad
        tienePropietario = titulo.tengoPropietario
      end
      
      if !es_de_mi_propiedad and tienePropietario
        encarcelado = titulo.propietarioEncarcelado
      end
      
      if !es_de_mi_propiedad and tienePropietario and !encarcelado
        estaHipotecada = titulo.hipotecada
      end
      
      deboPagar= !es_de_mi_propiedad and tienePropietario and !encarcelado and !estaHipotecada
    end

    def devolverCartaLibertad
      
      carta=@cartaLibertad
      @cartaLibertad=nil
      carta
      
    end

    def edificarCasa(titulo)
      edificada = false
        if puedoEdificarCasa(titulo)
          titulo.edificarCasa
          modificarSaldo(-titulo.precioEdificar)
          edificada = true
        end     
      edificada
     
    end 
    
    def edificarHotel(titulo)
      edificada=false
      
        if puedoEdificarHotel(titulo)
          titulo.edificarHotel
          modificarSaldo(-titulo.precioEdificar)
          edificada=true
        end
      
      edificada
    end 
    
    def eliminarDeMisPropiedades(titulo_propiedad) 
      @propiedades.delete(titulo_propiedad)
      titulo_propiedad.propietario = nil
    end
    
    def esDeMiPropiedad(titulo) 
      
      soyPropietario=false
      
      for k in @propiedades
        if titulo == k 
          soyPropietario=true
          break
        end
      end
      
      soyPropietario
      
    end
    
    def estoyEnCalleLibre
      loEstoy=false
      if @casillaActual.titulo.propietario=nil
        loEstoy=true
      end
      loEstoy
    end
    
    def hipotecarPropiedad(titulo)
      costeHipotecar = titulo.hipotecar
      modificarSaldo(costeHipotecar)
    end
    
    def irACarcel(casilla)
      @casillaActual = casilla
      @encarcelado = true
    end
    
    def modificarSaldo(cantidad)
      @saldo=@saldo+cantidad
    end
    
    def obtenerCapital
      
      total=0
      for j in @propiedades
        if j.hipotecada
          total=total+j.precioCompra+j.precioEdificar*(j.numCasas+j.numHoteles)+j.hipotecaBase
        else
          total=total+j.precioCompra+j.precioEdificar*(j.numCasas+j.numHoteles)
        end
      end
      
      total=total+@saldo
      
    end
    
    def obtenerPropiedades(estadoHipoteca)
      
      propiedades=Array.new
      for l in @propiedades
        if l.hipotecada==estadoHipoteca
          propiedades<<l
        end
      end
      propiedades
      
    end
    
    def pagarAlquiler 
      costeAlquiler = @casillaActual.pagarAlquiler
      modificarSaldo(-costeAlquiler)
    end
    
    def pagarImpuesto
      @saldo=@saldo-@casillaActual.coste
    end
    
    def pagarLibertad(cantidad)
      tengoSaldo = tengoSaldo(cantidad)
      if tengoSaldo
        @encarcelado = false
        modificarSaldo(-cantidad)
      end
    end

    def tengoCartaLibertad
      
      carta=true
      if @cartaLibertad==nil
        carta=false
      end
      carta
      
    end

    def tengoSaldo(cantidad)
      
      saldo_bool=false
      if @saldo>cantidad
        saldo_bool=true
      end
      saldo_bool
      
    end
    
    def venderPropiedad(casilla)
      titulo = casilla.titulo
      eliminarDeMisPropiedades(titulo)
      precioVenta = titulo.calcularPrecioVenta
      modificarSaldo(precioVenta)
    end
    
    def deboIrACarcel
      debo=!tengoCartaLibertad
      debo
    end
    
    def convertirme(fianza)
      especulador=Especulador.new(self,fianza)
      especulador
    end
    
    def puedoEdificarCasa(titulo)
      puedo=false
      numCasas = titulo.numCasas
      
      if numCasas < 4
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
      if numCasas==4
        costeEdificarHotel=titulo.precioEdificar
        tengoSaldo=tengoSaldo(costeEdificarHotel)
        if tengoSaldo==true
          puedo=true
        end
      end
      puedo
    end
  
 
  def to_s
       "------------------------------
        Jugador:
        Nombre: #{@nombre}
        Saldo: #{@saldo}
        Capital Jugador: #{obtenerCapital}
        Casilla actual: #{(@casillaActual == nil)? "NINGUNA" : @casillaActual}
        Encarcelado: #{(@encarcelado)? "SI" : "NO"}
        Carta de libertad: #{(@cartaLibertad == nil)? "NINGUNA" : @cartaLibertad}
        Propiedades: #{(@propiedades.size == 0)? "NINGUNA" : @propiedades.to_s}
      ------------------------------" 
    end  
    
  private
    :eliminarDeMisPropiedades
    :esDeMiPropiedad
    
  protected
    :convertirme
    :deboIrACarcel
    :copia
    :pagarImpuesto
    :puedoEdificarCasa
    :puedoEdificarHotel
    :tengoSaldo
  end
end
