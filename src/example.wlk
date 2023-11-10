// parcial Objetos  - Harry Botter

// modelo Bots
class Bot {
	var property cargaElectrica // un int
	var property aceitePuro // un bool
	method estaActivo() = cargaElectrica > 0
	method disminuirCargaElectrica(n) {cargaElectrica -= n}
	method llevarCargaA0() {self.cargaElectrica(0)}
	method ensuciarAceite() {self.aceitePuro(false)}
}

// sombrero seleccionador - ejercicio 1
object sombrero inherits Bot (cargaElectrica = 10, aceitePuro = true){
	var property ultimaCasa = hufflepuf							// guarda la última casa que asignó
	const casas = [gryffindor, slytherin, ravenclaw, hufflepuf]	// casas posibles
	method proximaCasa() {										//en base a la última casa que asignó, sabe cuál es la próxima a asignar
		ultimaCasa = ultimaCasa.proximaCasa()
		return ultimaCasa										// actualiza la última casa asignada
	}
	method asignarCasa(estudiante) = estudiante.casa(self.proximaCasa())
	override method ensuciarAceite() { self.aceitePuro() }
}

// bots Estudiantes y Profesores
class Estudiante inherits Bot{
	var property casa
	var property nombre = []
	var property hechizosAprendidos = []
	method esExperimentado() = hechizosAprendidos.size() > 3 && cargaElectrica > 50
	method lanzarHchizoA(hechizo,hechizado) = hechizo.lanzarA(hechizado)
	method aprenderHechizo(nuevoHechizo) = hechizosAprendidos.add(nuevoHechizo)
	method puedeLanzarHechizo(hechizo) = self.estaActivo() && hechizosAprendidos.contains(hechizo) && hechizo.cumpleCondiciones(self) // acá todavía no se contemplan las condiciones del hechizo
}
class Profesor inherits Estudiante{
	var property materiasDictadas // una cantidad
	override method esExperimentado() = super() && materiasDictadas >= 2
	override method disminuirCargaElectrica(n) {}
	override method llevarCargaA0() {cargaElectrica = cargaElectrica/2}
	method crearMateria() = new Materia (hechizoEnseniado = hechizosAprendidos.any(), profesor = self) // un porfesor puede crear una materia q él mismo dictará, es por eso que solo puede enseñar un hechizo que él sepa
}

// Casas
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

// Hechizos
class Hechizo{
	method cumpleCondiciones(lanzador) // para los hechizos genéricos
	method lanzarA(hechizado) //self.lanzarHechizoGenerico()// para los hechizos genéricos
	//method lanzarHechizoGenerico() 
}
object inmobulus inherits Hechizo {
	override method cumpleCondiciones(lanzador) = true
	override method lanzarA(estudiante) = estudiante.disminuirCargaElectrica(50)
}
object spectumSempra inherits Hechizo{
	override method cumpleCondiciones(lanzador) = lanzador.esExperimentado()
	override method lanzarA(hechizado) = hechizado.ensuciarAceite()
}
object avadakedabra inherits Hechizo{
	override method cumpleCondiciones(lanzador) = ! lanzador.aceitePuro()
	override method lanzarA(hechizado) = hechizado.llevarCargaA0()
}
// Nuevo hechizo - bubble sort, ordena alfabéticamente las letras del nombre del hechizado
object bubbleSortName inherits Hechizo{ 
	override method cumpleCondiciones(lanzador) = lanzador.nombre().size > 5 // el lanzador debe tener más de 5 letras en su nombre 
	override method lanzarA(hechizado) = hechizado.nombre().sortedBy({letra => letra})// revisar
}

// Materias
class Materia{
	var property hechizoEnseniado
	var property profesor
	method enseniarHechizo(estudiante) = estudiante.aprenderHechizo() 
}
object algoritmosYestructurasDeHechizos inherits Materia (hechizoEnseniado = bubbleSortName, profesor = 0){}




