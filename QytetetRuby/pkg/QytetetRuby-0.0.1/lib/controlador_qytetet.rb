#encoding: utf-8

require_relative "estado_juego"
require_relative "qytetet"


module Controlador
  class ControladorQytetet
    include ModeloQytetet
    
    @@Opcion_menu = [:INICIARJUEGO,:JUGAR,:APLICARSORPRESA,:INTENTARSALIRCARCELPAGANDOLIBERTAD,
        :INTENTARSALIRCARCELTIRANDODADO,:COMPRARTITULOPROPIEDAD,:HIPOTECARPROPIEDAD,
        :CANCELARHIPOTECA,:EDIFICARCASA,:EDIFICARHOTEL,:VENDERPROPIEDAD,:PASARTURNO,
        :OBTENERRANKING,:TERMINARJUEGO,:MOSTRARJUGADORACTUAL,:MOSTRARJUGADORES,:MOSTRARTABLERO]
      
    @@Modelo = Qytetet.instance
    attr_accessor :nombres_jugadores
    
    def self.get_modelo
      @@Modelo
    end
    
    def initialize(nombres)
      @nombres_jugadores = nombres
      
    end
    def self.get_Opcionmenu
      @@Opcion_menu
    end
    def ObtenerOperacionesJuegoValidas
      resultado = Array.new
      if @@Modelo.jugadores.empty?
        aux = @@Opcion_menu.index(:INICIARJUEGO)
        resultado << aux
        
      end
      if Qytetet.get_estadoJuego == EstadoJuego::JA_CONSORPRESA
        aux = @@Opcion_menu.index(:APLICARSORPRESA)
        resultado << aux;
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
      end
      
      if Qytetet.get_estadoJuego == EstadoJuego::ALGUNJUGADORENBANCARROTA
        aux = @@Opcion_menu.index(:OBTENERRANKING)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
      end
      
      if Qytetet.get_estadoJuego == EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
        aux = @@Opcion_menu.index(:PASARTURNO)
        resultado << aux
        aux = @@Opcion_menu.index(:COMPRARTITULOPROPIEDAD)
        resultado << aux
        aux = @@Opcion_menu.index(:VENDERPROPIEDAD)
        resultado << aux
        aux = @@Opcion_menu.index(:HIPOTECARPROPIEDAD)
        resultado << aux
        aux = @@Opcion_menu.index(:EDIFICARCASA)
        resultado << aux
        aux = @@Opcion_menu.index(:EDIFICARHOTEL)
        resultado << aux
        aux = @@Opcion_menu.index(:CANCELARHIPOTECA)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
      end
      
      if Qytetet.get_estadoJuego == EstadoJuego::JA_PUEDEGESTIONAR
        aux = @@Opcion_menu.index(:PASARTURNO)
        resultado << aux
        aux = @@Opcion_menu.index(:VENDERPROPIEDAD)
        resultado << aux
        aux = @@Opcion_menu.index(:HIPOTECARPROPIEDAD)
        resultado << aux
        aux = @@Opcion_menu.index(:EDIFICARCASA)
        resultado << aux
        aux = @@Opcion_menu.index(:EDIFICARHOTEL)
        resultado << aux
        aux = @@Opcion_menu.index(:CANCELARHIPOTECA)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
        
      end
      
      if Qytetet.get_estadoJuego == EstadoJuego::JA_PREPARADO
        aux = @@Opcion_menu.index(:JUGAR)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
      end
      
      if Qytetet.get_estadoJuego == EstadoJuego::JA_ENCARCELADO
        aux = @@Opcion_menu.index(:PASARTURNO)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
        
      end
      
      if Qytetet.get_estadoJuego== EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
        aux = @@Opcion_menu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
        resultado << aux
        aux = @@Opcion_menu.index(:INTENTARSALIRCARCELTIRANDODADO)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado << aux
        aux = @@Opcion_menu.index(:MOSTRARTABLERO)
        resultado << aux
        aux = @@Opcion_menu.index(:TERMINARJUEGO)
        resultado << aux
      end
      
      resultado
      
    end
    
    def necesitaElegirCasilla(opcion_menu)
      opcion_menu = opcion_menu.to_i
      aux = false
      if opcion_menu == @@Opcion_menu.index(:HIPOTECARPROPIEDAD) || opcion_menu == @@Opcion_menu.index(:CANCELARHIPOTECA) ||
         opcion_menu==@@Opcion_menu.index(:EDIFICARCASA) || opcion_menu==@@Opcion_menu.index(:EDIFICARHOTEL) || opcion_menu == @@Opcion_menu.index(:VENDERPROPIEDAD)
       aux = true
      
      end
      
      return aux
    end
    
    def obtenerCasillasValidas(opcion_menu)
      if opcion_menu == @@Opcion_menu.index(:HIPOTECARPROPIEDAD)
        estado = false
        
        propiedades = @@Modelo.obtenerPropiedadesSegunEstadoHipoteca(estado)
      end
      
      if opcion_menu == @@Opcion_menu.index(:CANCELARHIPOTECA)
        estado = true
        propiedades = @@Modelo.obtenerPropiedadesSegunEstadoHipoteca(estado)
      end
      
      if opcion_menu == @@Opcion_menu.index(:EDIFICARCASA) ||opcion_menu == @@Opcion_menu.index(:EDIFICARHOTEL) ||opcion_menu == @@Opcion_menu.index(:VENDERPROPIEDAD)
        propiedades = @@Modelo.obtenerPropiedadesJugador
      end
      
      propiedades
      
    end
    
    def realizarOperacion(opcion_menu,casilla_elegida)
      
      if opcion_menu==@@Opcion_menu.index(:INICIARJUEGO)
        @@Modelo.inicializarJuego(@nombres_jugadores)
        resultado = @@Modelo.to_s
        

      end
      
      if opcion_menu==@@Opcion_menu.index(:JUGAR)
        @@Modelo.jugar
        resultado = @@Modelo.dado.to_s + @@Modelo.jugadorActual.casillaActual.to_s
        
      end
      
      if opcion_menu==@@Opcion_menu.index(:APLICARSORPRESA)
        resultado = Qytetet.get_estadoJuego.to_s
        @@Modelo.aplicarSorpresa
        
        
      end
      
      if opcion_menu==@@Opcion_menu.index(:MOSTRARTABLERO)
        resultado = @@Modelo.tablero.to_s
        
      end
      if opcion_menu==@@Opcion_menu.index(:MOSTRARJUGADORES)
        resultado = "Jugadores : #{@@Modelo.jugadores.join}" 
      end
      
      if opcion_menu==@@Opcion_menu.index(:MOSTRARJUGADORACTUAL)
        resultado = @@Modelo.jugadorActual.to_s
        
      end
      if opcion_menu==@@Opcion_menu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
        metodo = MetodoSalirCarcel::TIRANDODADO
        @@Modelo.intentarSalirCarcel(metodo)
        resultado = @@Modelo.jugadorActual.to_s
        
      end
      if opcion_menu == @@Opcion_menu.index(:INTENTARSALIRCARCELTIRANDODADO) 
        metodo = MetodoSalirCarcel::PAGANDOLIBERTAD
        @@Modelo.intentarSalirCarcel(metodo)
        resultado = @@Modelo.jugadorActual.to_s
        
        
      end
      if opcion_menu == @@Opcion_menu.index(:COMPRARTITULOPROPIEDAD)
        
        aux = @@Modelo.comprarTituloPropiedad
        resultado = @@Modelo.jugadorActual.to_s 
        
      end
      
      if opcion_menu == @@Opcion_menu.index(:HIPOTECARPROPIEDAD)
        @@Modelo.hipotecarPropiedad(casilla_elegida)
        resultado = "la operacion hipotecar propiedad se ha efectuado con exito"
      end
      
      if opcion_menu == @@Opcion_menu.index(:CANCELARHIPOTECA)
        @@Modelo.cancelarHipoteca(casilla_elegida)
        resultado = "la operacion cancelar hipoteca se ha efectuado con exito"
      end
      
      if opcion_menu == @@Opcion_menu.index(:EDIFICARCASA)
        aux = @@Modelo.edificarCasa(casilla_elegida)
        resultado = "el resultado de la operacion es #{aux}" 
      end
      
      if opcion_menu == @@Opcion_menu.index(:EDIFICARHOTEL)
        aux = @@Modelo.edificarHotel(casilla_elegida)
        resultado = "el resultado de la operacion es #{aux}"
      end
      
      if opcion_menu == @@Opcion_menu.index(:VENDERPROPIEDAD)
       
        @@Modelo.venderPropiedad(casilla_elegida)
        resultado = "La operacion vender propiedad se ha realizado con exito"
      end
      
      if opcion_menu == @@Opcion_menu.index(:PASARTURNO)
        @@Modelo.siguienteJugador
        resultado = "has pasado turno"
      end
      
      if opcion_menu == @@Opcion_menu.index(:OBTENERRANKING)
        @@Modelo.obtenerRanking
        for i in @@Modelo.jugadores
          resultado=resultado+i.to_s
        end
      end
      
      if opcion_menu == @@Opcion_menu.index(:TERMINARJUEGO)
        resultado = 'TERMINAR'
      end
     
      
      resultado
      
      
    end
    
  end
end
