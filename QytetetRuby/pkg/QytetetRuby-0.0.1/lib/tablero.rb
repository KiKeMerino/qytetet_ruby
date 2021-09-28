#enconding: utf-8
require_relative "tipo_casilla"
require_relative "casilla"
require_relative "titulo_propiedad"
require_relative "calle"
module ModeloQytetet
  class Tablero   
    
    attr_accessor :casillas, :carcel
    
    def initialize
      @casillas=Array.new
      @carcel=Casilla.new(6,TipoCasilla::CARCEL)
      
@casillas = Array.new
      @carcel = Casilla.new(5, TipoCasilla::CARCEL)
      
      @casillas<< Casilla.new(0, TipoCasilla::SALIDA)
      @casillas<< Calle.new(1, TituloPropiedad.new("Despegue Inicial", 350, 50, 10, 150, 250))
      @casillas<< Casilla.new(2, TipoCasilla::SORPRESA)
      @casillas<< Calle.new(3, TituloPropiedad.new("Aldea Estroncho", 500, 55, 12, 230, 250))
      @casillas<< Calle.new(4, TituloPropiedad.new("Wisconsin", 650, 60, 14, 310, 350))
      @casillas<< @carcel
      @casillas<< Calle.new(6, TituloPropiedad.new("Massachusetts", 800, 65, 16, 390, 350))
      @casillas<< Calle.new(7, TituloPropiedad.new("Charca Churrete", 950, 70, 18, 470, 450))
      @casillas<< Casilla.new(8, TipoCasilla::SORPRESA)
      @casillas<< Calle.new(9, TituloPropiedad.new("Mansion de la Biribimafia", 1100, 75, 20, 550, 450))
      @casillas<< Casilla.new(10, TipoCasilla::PARKING)
      @casillas<< Calle.new(11, TituloPropiedad.new("Gotham", 1250, 80, -10, 630, 550))
      @casillas<< Calle.new(12, TituloPropiedad.new("Chiringuito de Peponcho", 1400, 85, -12, 710, 550))
      @casillas<< Casilla.new(13, TipoCasilla::IMPUESTO)
      @casillas<< Calle.new(14, TituloPropiedad.new("Mansion Gucci", 1550, 90, -14, 790, 650))
      @casillas<< Casilla.new(15, TipoCasilla::JUEZ)
      @casillas<< Calle.new(16, TituloPropiedad.new("Borrasca Torrencial", 1700, 95, -16, 870, 650))
      @casillas<< Casilla.new(17, TipoCasilla::SORPRESA)
      @casillas<< Calle.new(18, TituloPropiedad.new("Islas Paradisiacas", 1850, 100, -18, 950, 750))
      @casillas<< Casilla.new(19, TituloPropiedad.new("Mansion Buendia", 200, 100, -20, 1000, 750))
      @NUM_CASILLAS = 20
    end
    
    def esCasillaCarcel(numeroCasilla)
      
      if numeroCasilla==@carcel.numeroCasilla
        esCarcel=true
      else
        esCarcel=false
      end
      esCarcel
      
    end
    
    def obtenerCasillaFinal(casilla, desplazamiento)
      @casillas.at((casilla.numeroCasilla+desplazamiento)%@NUM_CASILLAS)
    end
    
    def obtenerCasillaNumero(numeroCasilla)
      casilla=@casillas[numeroCasilla]
    end
   
    def to_s
            
      puts "TABLERO: "
      puts @casillas
    
    end
    
  private
    :initialize

  end
end
