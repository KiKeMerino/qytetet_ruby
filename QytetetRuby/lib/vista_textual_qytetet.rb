#encoding: utf-8

require_relative "controlador_qytetet"
require_relative "estado_juego"


module Vista
  class VistaTextualQytetet
      include Controlador
      
      
      attr_accessor :controlador
      
      def initialize(nombres)
        @controlador = ControladorQytetet.new(nombres)

        @auxiliar = 0
      end
      
    def obtenerNombreJugadores
      aux = @controlador.nombre_jugadores
      aux
     
    end
    
    def elegirCasilla (opcionMenu)
      casillas = Array.new
      casillas = @controlador.obtenerCasillasValidas(opcionMenu)
      
      if casillas.empty?
        puts "No hay títulos para realizar la operacion"
        return -1
        
      else
        puts "La lista es: "
        puts casillas
        
        aux = Array.new
        
        for i in casillas 
          aux << i.to_s
        end
        
        cadena = leerValorCorrecto (aux)
        resultado = cadena.to_i
        
        return resultado
      end
    end
    
    
    def leerValorCorrecto(valores_correctos)
      loop do
        @auxiliar = gets.chomp
        resultado = false
        for i in valores_correctos
          if @auxiliar == i
            resultado = true
          end
        end
        if resultado == false
          puts "ERROR, VUELVE A INTRODUCIR UN VALOR"
        end
        break if resultado == true
      end
      
      @auxiliar
      
    end
    
    
    def elegirOperacion
      aux = Array.new
      aux = @controlador.ObtenerOperacionesJuegoValidas
      lista = Array.new
      lista_nombres = Array.new
      for i in aux
        lista << i.to_s
        lista_nombres << "" + i.to_s + " " + ControladorQytetet.get_Opcionmenu[i].to_s 
      end
      #puts "#{lista}"
      puts "#{lista_nombres}"
      resultado = leerValorCorrecto(lista)
      
      
      resultado
      
    end 
    def self.getsNombreJugadores 
      entero = gets.chomp
          nombres=Array.new
          for i in (1..Integer(entero))
           nombres<<gets
        end
       
         nombres
      end
    
      def self.main
        puts "Introduce el numero de jugadores y sus nombres a continuacion"
        names=Array.new
        names=VistaTextualQytetet.getsNombreJugadores
        vista = VistaTextualQytetet.new(names)
          
          loop do 
            puts "Operaciones validas : "
            operacion_elegida = vista.elegirOperacion
            puts "la operacion es : #{operacion_elegida}"
            
            necesita_elegir_casilla = vista.controlador.necesitaElegirCasilla(operacion_elegida)
            puts "necesita casilla  : #{necesita_elegir_casilla}"
            
            
            if necesita_elegir_casilla == true
              casilla_elegida = vista.controlador.obtenerCasillasValidas(operacion_elegida)
              
              
              casilla_elegida = gets.chomp
              casilla_elegida = Integer(casilla_elegida)
            end
            
            if necesita_elegir_casilla == false || casilla_elegida >= 0
              
              variable = vista.controlador.realizarOperacion(operacion_elegida.to_i, casilla_elegida)
              puts "#{variable}"
              
              
            end
            
            break if variable == "TERMINAR"
          end
          
      end

  end
  VistaTextualQytetet.main
end

