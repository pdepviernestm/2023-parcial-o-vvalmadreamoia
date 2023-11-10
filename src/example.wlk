// parcial Objetos  - Harry Botter
class Bot {
	var property cargaElectrica // un int
	var property aceitePuro // un bool
	method estaActivo() = cargaElectrica > 0
}

class Escoba inherits Bot{
	
}
class Varitas inherits Bot{
	
}
//object snich inherits Bot ( cargaElectrica = 0, aceite = 0)

/*object sombrero inherits Bot(
	cargaElectrica = 0
	aceite = 0
	method sleccionar() = {}
	)*/
object sombrero{
	var property ultimaCasa = hufflepuf		// guarda la última casa que asignó
	const casas = [gryffindor, slytherin, ravenclaw, hufflepuf]	// casas posibles
	method proximaCasa() {		//en base a la última casa que asignó, sabe cuál es la próxima a asignar
		ultimaCasa = ultimaCasa.proximaCasa()
		return ultimaCasa		// actualiza la última casa asignada
	}
	method asignarCasa(estudiante) = estudiante.casa(self.proximaCasa())
}

class Estudiante inherits Bot{
	var property casa
	var property hechizosAprendidos = []
	method asistirAclase()
	method aprenderHechizo(nuevoHechizo) = hechizosAprendidos.add(nuevoHechizo)
	method puedeLanzarHechizo(hechizo) = self.estaActivo() && hechizosAprendidos.contains(hechizo)
}
class Casa {
	var property estudiantes = []
	method esPeligrosa() = false
}
object gryffindor inherits Casa{
	method proximaCasa() = slytherin
}
object slytherin inherits Casa{
	override method esPeligrosa() = true
	method proximaCasa() = ravenclaw
}
object ravenclaw inherits Casa{
	method estudiantesAceitePuro() = estudiantes.filter({estudiante => estudiante.aceitePuro()}).size()
	override method esPeligrosa() = estudiantes.size()/2 > self.estudiantesAceitePuro()
	method proximaCasa() = hufflepuf
}
object hufflepuf inherits Casa{
	method estudiantesAceitePuro() = estudiantes.filter({estudiante => estudiante.aceitePuro()}).size()
	override method esPeligrosa() = estudiantes.size()/2 > self.estudiantesAceitePuro()
	method proximaCasa() = gryffindor
}