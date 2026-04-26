from __future__ import annotations

from copy import deepcopy
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile
import xml.etree.ElementTree as ET
import sys

def get_script_dir() -> Path:
    return Path(__file__).parent

def get_base_pptx() -> Path:
    if len(sys.argv) > 1:
        return Path(sys.argv[1])
    return get_script_dir().parent.parent / "Copia de Conferenciade MetodologÃ_as Ã_giles_Docencia_UASD (1).pptx"

def get_output_pptx() -> Path:
    if len(sys.argv) > 2:
        return Path(sys.argv[2])
    return get_script_dir() / "Marlenis-Concepcion-INF8236-Tarea-5.1-Presentacion.pptx"

BASE_PPTX = get_base_pptx()
OUTPUT_PPTX = get_output_pptx()

NS = {
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "p": "http://schemas.openxmlformats.org/presentationml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    "pr": "http://schemas.openxmlformats.org/package/2006/relationships",
}

ET.register_namespace("a", NS["a"])
ET.register_namespace("r", NS["r"])
ET.register_namespace("", NS["p"])

SLIDE_PLAN = {
    1: {
        "source": 1,
        "texts": {
            1: ["UNIVERSIDAD AUTONOMA DE SANTO DOMINGO"],
            2: ["Primada de America  |  Fundada el 28 de octubre de 1538"],
            3: [
                "TAREA 5.1: CONSULTAS AVANZADAS, SP Y TRIGGER",
                "DBNomina en SQL Server - Unidad 5",
            ],
            4: [
                "Base de Datos I  |  INF-8236-C2  |  Maestria en Ciencia de Datos e IA",
            ],
            5: [
                "Mannix  -  Roberto Byas  -  Victor Perez  -  Marlenis Concepcion  -  Abril 2026",
            ],
        },
        "remove_images": ["image7.jpg"],
    },
    2: {
        "source": 2,
        "texts": {
            1: ["Grupo y distribucion de exposicion"],
            2: [
                "Mannix   ->  Diapositivas 3 a 6  |  Contexto, alcance, modelo DBNomina y datos de prueba",
                "Roberto  ->  Diapositivas 7 a 9  |  Planes de ejecucion, indices y estadisticas",
                "Victor   ->  Diapositivas 10 a 12 | ACID, COMMIT, ROLLBACK, SAVEPOINT, concurrencia y aislamiento",
                "Marlenis ->  Diapositivas 13 a 18 | Stored procedures, funcion, triggers, vista indexada, seguridad y evidencias",
                "",
                "Portada y cierre: diapositivas 1, 2 y 19 se pueden manejar entre todos o abrir/cerrar Marlenis.",
                "Asignatura: Base de Datos I  |  INF-8236-C2",
                "Tutora: Mtra. Rosmery Alberto M.",
                "Enfoque: a Marlenis se le deja la parte mas tecnica de los scripts.",
            ],
        },
        "remove_all_images": True,
    },
    3: {
        "source": 3,
        "texts": {
            1: ["Seccion", "I"],
            2: [
                "Contexto de la tarea",
                "Unidad 5 - Administracion y optimizacion",
                "Base de datos: DBNomina",
                "Consultas avanzadas, SP, triggers y seguridad",
                "Presenta: Mannix",
            ],
            3: ["Contexto", "DBNomina"],
        },
    },
    4: {
        "source": 10,
        "texts": {
            1: [
                "Objetivo y alcance de la entrega",
                "La solucion cubre los 12 ejercicios solicitados por la tutora en SQL Server.",
                "Se construyo la base DBNomina con tablas maestras, transaccionales, auditoria, historico y cache.",
                "Tambien se integraron indices, estadisticas, transacciones controladas, procedimientos almacenados, funcion, triggers, vista indexada y seguridad.",
                "La entrega final incluye script SQL, documento de respuestas y esta presentacion.",
                "Se adaptaron nombres y contexto academico a la realidad de la asignatura INF-8236-C2.",
            ]
        },
        "remove_all_images": True,
    },
    5: {
        "source": 40,
        "texts": {
            1: [
                "Modelo DBNomina - Tablas principales",
                "Compania: tabla maestra de la institucion; se uso codigo UAS.",
                "TipoPeriodoNomina: MEN, QUI y DIA, agregada para completar el modelo del enunciado.",
                "Departamento: ADM, FIN, DOC y TIC.",
                "Empleado: datos personales, cargo, sueldo base, estado y relacion con compania/departamento.",
                "TipoNomina: FIX, DOC y EXT vinculadas al tipo de periodo.",
                "PeriodoNomina: enero, febrero y marzo 2026.",
                "TransaccionNomina: pagos, montos, deducciones, neto, estado y trazabilidad.",
            ]
        },
        "remove_all_images": True,
    },
    6: {
        "source": 41,
        "texts": {
            1: [
                "Datos de prueba y reglas de calculo",
                "Se cargaron 7 empleados: Marlenis, Roberto Byas, Victor Perez Padilla, Manicaotex, Rosmery, Ana Martinez y Jose Amado.",
                "Se registraron transacciones 1001 a 1010 para demostrar consultas, COMMIT, SAVEPOINT, triggers y DELETE historico.",
                "Reglas de Republica Dominicana aplicadas en el SP de calculo:",
                "AFP empleado = 2.87% con tope SVDS 2026 de RD$464,460.00",
                "ARS empleado = 3.04% con tope SFS 2026 de RD$232,230.00",
                "ISR 2026 usando la escala oficial de DGII sobre el ingreso anual gravado.",
            ]
        },
        "remove_all_images": True,
    },
    7: {
        "source": 15,
        "texts": {
            1: ["Seccion", "II"],
            2: [
                "Optimizacion de consultas",
                "Plan de ejecucion inicial",
                "Indice no agrupado por Empleado_ID",
                "Actualizacion de estadisticas",
                "Comparacion antes y despues",
                "Presenta: Roberto",
            ],
            3: ["Tuning", "SQL Server"],
        },
    },
    8: {
        "source": 43,
        "texts": {
            1: [
                "Ejercicio 1 y 2 - Plan de ejecucion e indice",
                "Consulta analizada: SELECT * FROM dbo.TransaccionNomina WHERE Empleado_ID = 3;",
                "Antes de crear el indice: operacion esperada = Clustered Index Scan.",
                "Despues de crear IX_TransaccionNomina_Empleado_ID: operacion esperada = NonClustered Index Seek.",
                "Si se mantiene SELECT *, SQL Server puede agregar Key Lookup segun el plan real.",
                "Conclusión: el indice reduce lecturas innecesarias y mejora el tiempo de acceso por empleado.",
                "Resultado de la consulta para Empleado_ID = 3: transacciones 1003 y 1006.",
            ]
        },
        "remove_all_images": True,
    },
    9: {
        "source": 44,
        "texts": {
            1: [
                "Ejercicio 3 - Estadisticas y optimizador",
                "Comando ejecutado: UPDATE STATISTICS dbo.TransaccionNomina;",
                "Consulta evaluada: WHERE TransaccionNomina_Monto > 20000",
                "La tabla devolvio las transacciones 1001 a 1009, porque todas superan RD$20,000 excepto que 1010 luego se elimina.",
                "Las estadisticas ayudan al optimizador a estimar cardinalidad, costo y mejor estrategia de acceso.",
                "Sin estadisticas actualizadas puede elegir un plan poco eficiente.",
                "Con estadisticas correctas mejora la precision del plan para filtros, joins y agregaciones.",
            ]
        },
        "remove_all_images": True,
    },
    10: {
        "source": 34,
        "texts": {
            1: ["Seccion", "III"],
            2: [
                "Transacciones y concurrencia",
                "ACID, COMMIT, ROLLBACK y SAVEPOINT",
                "Bloqueos y nivel READ COMMITTED",
                "Control de consistencia",
                "Caso practico en DBNomina",
                "Presenta: Victor",
            ],
            3: ["ACID", "Concurrencia"],
        },
    },
    11: {
        "source": 40,
        "texts": {
            1: [
                "Ejercicio 4 y 5 - COMMIT, ROLLBACK y SAVEPOINT",
                "Transaccion con COMMIT: se inserto el pago 1007 para Ana Martinez y quedo confirmado.",
                "Resultado 1007: bruto RD$32,000.00, AFP RD$918.40, ARS RD$972.80, ISR RD$0.00, neto RD$30,108.80.",
                "Prueba con SAVEPOINT: se insertaron 1008 y 1009 y luego se hizo una actualizacion posterior al punto parcial.",
                "Al ejecutar ROLLBACK TRAN PuntoParcial, la actualizacion se revirtio pero los INSERT permanecieron.",
                "Ventaja: permite rollback parcial sin perder toda la transaccion.",
            ]
        },
        "remove_all_images": True,
    },
    12: {
        "source": 41,
        "texts": {
            1: [
                "Ejercicio 6 y 7 - Bloqueos y aislamiento",
                "Sesion 1: UPDATE dbo.Empleado SET Empleado_SueldoBase = 83000 WHERE Empleado_ID = 3; sin COMMIT.",
                "Sesion 2: intenta actualizar el mismo Empleado_ID = 3 y queda esperando el recurso.",
                "La causa es un bloqueo exclusivo retenido por la primera transaccion.",
                "Nivel configurado: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;",
                "Este nivel evita dirty reads, es decir, lecturas de datos todavia no confirmados.",
                "Conclusión: mejora la consistencia sin llegar al costo de aislamiento mas alto.",
            ]
        },
        "remove_all_images": True,
    },
    13: {
        "source": 37,
        "texts": {
            1: ["Seccion", "IV"],
            2: [
                "Programabilidad en SQL Server",
                "Stored Procedures",
                "Funcion escalar",
                "Triggers de auditoria, cache e historico",
                "Automatizacion del proceso de nomina",
                "Presenta: Marlenis",
            ],
            3: ["SP", "Triggers"],
        },
    },
    14: {
        "source": 43,
        "texts": {
            1: [
                "Stored Procedures implementados",
                "SP_Actualizar_TransaccionesNomina: calcula sueldo base, AFP, ARS, ISR y neto.",
                "SP_Consultar_NominaEmpleado: lista todas las transacciones de un empleado.",
                "SP_Insertar_EmpleadoLog: inserta auditoria de INSERT, UPDATE y DELETE en Empleado.",
                "SP_Insertar_TransaccionNominaLog: registra auditoria de cambios en TransaccionNomina.",
                "SP_Insertar_TransaccionesNominaHistorico: guarda historico al eliminar una transaccion.",
                "Ejemplo documentado: EXEC dbo.SP_Consultar_NominaEmpleado @Empleado_ID = 3;",
            ]
        },
        "remove_all_images": True,
    },
    15: {
        "source": 44,
        "texts": {
            1: [
                "Funcion y triggers creados",
                "FN_SalarioAnual(@SueldoMensual): retorna sueldo mensual x 12.",
                "Trigger 1: TR_TransaccionNomina_AfterInsert_Actualizar -> ejecuta SP_Actualizar_TransaccionesNomina.",
                "Trigger 2: TR_TransaccionNomina_AfterInsert_ConsultarEmpleado -> llena NominaEmpleadoConsultaCache.",
                "Trigger 3: TR_Empleado_Audit -> registra cambios en EmpleadoLog.",
                "Trigger 4: TR_TransaccionNomina_Audit -> registra eventos en TransaccionNominaLog.",
                "Trigger 5: TR_TransaccionNomina_Historico -> al DELETE archiva la transaccion en historico.",
            ]
        },
        "remove_all_images": True,
    },
    16: {
        "source": 40,
        "texts": {
            1: [
                "Vista indexada y seguridad",
                "VW_TotalNominaEmpleado se creo con WITH SCHEMABINDING como indexed view.",
                "Agrega por Empleado_ID la cantidad de transacciones y el total pagado neto.",
                "Se creo el indice unico clustered IX_VW_TotalNominaEmpleado.",
                "En seguridad se creo el login login_consulta_nomina_marlenis y el usuario user_consulta_nomina_marlenis.",
                "Se creo el rol RolConsultaNomina con permisos SELECT sobre tablas de nomina y la vista.",
                "Aplicacion del principio de minimo privilegio: solo lectura, sin permisos de escritura.",
            ]
        },
        "remove_all_images": True,
    },
    17: {
        "source": 41,
        "texts": {
            1: [
                "Evidencias de corrida mas importantes",
                "Empleado_ID = 3 devuelve las transacciones 1003 y 1006.",
                "1007 confirmado con COMMIT para Ana Martinez: neto RD$30,108.80.",
                "1008 y 1009 permanecen luego del rollback parcial al SAVEPOINT.",
                "Insertar 1010 para Jose Amado dispara calculo automatico, cache y auditoria.",
                "Eliminar 1010 genera registro historico DELETE con neto RD$58,989.11.",
                "La vista indexada muestra como mayor total pagado a Rosmery con RD$188,240.97.",
            ]
        },
        "remove_all_images": True,
    },
    18: {
        "source": 43,
        "texts": {
            1: [
                "Referencias oficiales usadas en los calculos",
                "DGII - Escala de ISR 2026 para asalariados.",
                "DGII - Comunidad de ayuda sobre escala salarial 2026.",
                "TSS - Manual de preguntas frecuentes, porcentajes de retencion y aporte.",
                "TSS - Topes de cotizacion del regimen contributivo vigentes para 2026.",
                "Estas referencias sustentan los porcentajes AFP 2.87%, ARS 3.04% y el ISR aplicado en el stored procedure.",
                "La presentacion resume la entrega, mientras el detalle completo esta en el SQL y el PDF de evidencias.",
            ]
        },
        "remove_all_images": True,
    },
    19: {
        "source": 42,
        "texts": {
            1: ["Cierre", "Final"],
            2: [
                "Conclusiones y archivos entregados",
                "Se resolvieron los 12 ejercicios solicitados para la Tarea 5.1.",
                "Se entregan: script SQL Server, PDF de respuestas y esta presentacion.",
                "Distribucion final: Mannix (contexto), Roberto (optimizacion), Victor (transacciones), Marlenis (scripts tecnicos).",
                "Archivos clave:",
                "Marlenis-Concepcion-INF8236-Tarea-5.1-DBNomina.sql",
                "Marlenis-Concepcion-INF8236-Tarea-5.1-Respuestas-y-Evidencias.pdf",
                "Gracias.",
            ],
            3: ["Marlenis", "INF-8236-C2"],
        },
    },
}


def qn(prefix: str, tag: str) -> str:
    return f"{{{NS[prefix]}}}{tag}"


def read_xml(path: Path) -> ET.ElementTree:
    return ET.parse(path)


def save_xml(tree: ET.ElementTree, path: Path) -> None:
    tree.write(path, encoding="utf-8", xml_declaration=True)


def build_source_cache(workdir: Path, slide_numbers: set[int]) -> dict[int, tuple[bytes, bytes]]:
    cache: dict[int, tuple[bytes, bytes]] = {}
    for slide_number in slide_numbers:
        slide_path = workdir / "ppt" / "slides" / f"slide{slide_number}.xml"
        rels_path = workdir / "ppt" / "slides" / "_rels" / f"slide{slide_number}.xml.rels"
        cache[slide_number] = (slide_path.read_bytes(), rels_path.read_bytes())
    return cache


def copy_slide_files(workdir: Path, source_cache: dict[int, tuple[bytes, bytes]], src_num: int, dst_num: int) -> None:
    (workdir / "ppt" / "slides" / f"slide{dst_num}.xml").write_bytes(source_cache[src_num][0])
    (workdir / "ppt" / "slides" / "_rels" / f"slide{dst_num}.xml.rels").write_bytes(source_cache[src_num][1])


def build_rel_target_map(rels_root: ET.Element) -> dict[str, str]:
    return {
        rel.attrib["Id"]: rel.attrib.get("Target", "")
        for rel in rels_root.findall(qn("pr", "Relationship"))
    }


def find_shape_by_index(slide_root: ET.Element, index: int) -> ET.Element:
    shapes = slide_root.findall(f".//{qn('p', 'sp')}")
    return shapes[index - 1]


def rebuild_text_body(shape: ET.Element, paragraphs: list[str]) -> None:
    tx_body = shape.find(qn("p", "txBody"))
    if tx_body is None:
        return

    old_paragraphs = tx_body.findall(qn("a", "p"))
    template_paragraph = old_paragraphs[0] if old_paragraphs else None
    template_ppr = template_paragraph.find(qn("a", "pPr")) if template_paragraph is not None else None
    template_run = template_paragraph.find(qn("a", "r")) if template_paragraph is not None else None
    template_rpr = template_run.find(qn("a", "rPr")) if template_run is not None else None
    template_end = template_paragraph.find(qn("a", "endParaRPr")) if template_paragraph is not None else None

    for paragraph in list(tx_body.findall(qn("a", "p"))):
        tx_body.remove(paragraph)

    if not paragraphs:
        new_paragraph = ET.Element(qn("a", "p"))
        if template_end is not None:
            new_paragraph.append(deepcopy(template_end))
        tx_body.append(new_paragraph)
        return

    for text in paragraphs:
        new_paragraph = ET.Element(qn("a", "p"))
        if template_ppr is not None:
            new_paragraph.append(deepcopy(template_ppr))
        run = ET.SubElement(new_paragraph, qn("a", "r"))
        if template_rpr is not None:
            cleaned_rpr = deepcopy(template_rpr)
            for link_tag in [qn("a", "hlinkClick"), qn("a", "hlinkMouseOver")]:
                for link_node in list(cleaned_rpr.findall(link_tag)):
                    cleaned_rpr.remove(link_node)
            run.append(cleaned_rpr)
        text_node = ET.SubElement(run, qn("a", "t"))
        text_node.text = text
        if template_end is not None:
            new_paragraph.append(deepcopy(template_end))
        tx_body.append(new_paragraph)


def remove_all_pictures(slide_root: ET.Element) -> None:
    for parent in slide_root.findall(f".//{qn('p', 'spTree')}"):
        for pic in list(parent.findall(qn("p", "pic"))):
            parent.remove(pic)


def remove_selected_pictures(slide_root: ET.Element, rels_root: ET.Element, image_names: list[str]) -> None:
    if not image_names:
        return
    rel_map = build_rel_target_map(rels_root)
    images = set(image_names)
    for parent in slide_root.findall(f".//{qn('p', 'spTree')}"):
        for pic in list(parent.findall(qn("p", "pic"))):
            blip = pic.find(f".//{qn('a', 'blip')}")
            if blip is None:
                continue
            rel_id = blip.attrib.get(qn("r", "embed"))
            target = rel_map.get(rel_id, "")
            if Path(target).name in images:
                parent.remove(pic)


def strip_hyperlinks(slide_root: ET.Element) -> None:
    for parent in slide_root.iter():
        for link_tag in [qn("a", "hlinkClick"), qn("a", "hlinkMouseOver")]:
            for link_node in list(parent.findall(link_tag)):
                parent.remove(link_node)


def referenced_relationship_ids(slide_root: ET.Element) -> set[str]:
    used_ids: set[str] = set()
    rel_ns = f"{{{NS['r']}}}"
    for element in slide_root.iter():
        for attr_name, attr_value in element.attrib.items():
            if attr_name.startswith(rel_ns):
                used_ids.add(attr_value)
    return used_ids


def sanitize_relationships(rels_root: ET.Element, keep_ids: set[str]) -> None:
    for rel in list(rels_root):
        rel_type = rel.attrib.get("Type", "")
        rel_id = rel.attrib.get("Id", "")
        if "slideLayout" in rel_type or rel_id in keep_ids:
            continue
        rels_root.remove(rel)


def trim_presentation_to_n_slides(workdir: Path, slide_count: int) -> None:
    presentation_path = workdir / "ppt" / "presentation.xml"
    tree = read_xml(presentation_path)
    root = tree.getroot()
    slide_list = root.find(qn("p", "sldIdLst"))
    for slide_ref in list(slide_list)[slide_count:]:
        slide_list.remove(slide_ref)
    save_xml(tree, presentation_path)


def repackage(source_dir: Path, output_path: Path) -> None:
    with ZipFile(output_path, "w", ZIP_DEFLATED) as zf:
        for file_path in sorted(source_dir.rglob("*")):
            if file_path.is_file():
                zf.write(file_path, file_path.relative_to(source_dir))


def main() -> None:
    total_slides = len(SLIDE_PLAN)
    with TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        with ZipFile(BASE_PPTX) as zf:
            zf.extractall(temp_path)

        trim_presentation_to_n_slides(temp_path, total_slides)
        source_cache = build_source_cache(temp_path, {config["source"] for config in SLIDE_PLAN.values()})

        for dst_num, config in SLIDE_PLAN.items():
            copy_slide_files(temp_path, source_cache, config["source"], dst_num)

            slide_path = temp_path / "ppt" / "slides" / f"slide{dst_num}.xml"
            rels_path = temp_path / "ppt" / "slides" / "_rels" / f"slide{dst_num}.xml.rels"

            slide_tree = read_xml(slide_path)
            slide_root = slide_tree.getroot()
            rels_tree = read_xml(rels_path)
            rels_root = rels_tree.getroot()

            if config.get("remove_all_images"):
                remove_all_pictures(slide_root)
            if config.get("remove_images"):
                remove_selected_pictures(slide_root, rels_root, config["remove_images"])

            for shape_index, paragraphs in config["texts"].items():
                try:
                    rebuild_text_body(find_shape_by_index(slide_root, shape_index), paragraphs)
                except IndexError:
                    pass

            strip_hyperlinks(slide_root)
            keep_ids = referenced_relationship_ids(slide_root)
            sanitize_relationships(rels_root, keep_ids)

            save_xml(slide_tree, slide_path)
            save_xml(rels_tree, rels_path)

        repackage(temp_path, OUTPUT_PPTX)

    print(f"Presentacion generada: {OUTPUT_PPTX}")
    print(f"Total de diapositivas: {total_slides}")


if __name__ == "__main__":
    main()
