# Changelog

## Próxima versión

### Yazi

- Yazi se comprueba e instala automáticamente durante la fase de paquetes.
- Nueva opción `11) Instalar o actualizar Yazi` en el menú principal.
- Nuevo script `bin/install-yazi.sh` con soporte para `pacman`, `apt`, `dnf`
  y alternativa mediante Snap cuando el paquete no está disponible.
- Las instalaciones y actualizaciones requieren confirmación explícita.
- La instalación guiada conserva su comportamiento: si Yazi ya existe, no
  fuerza una actualización.
- Wrapper oficial `y` integrado en `config/zsh/zshrc`.
- Al salir de Yazi con `q`, Zsh cambia al directorio navegado; con `Q`, mantiene
  el directorio desde el que se abrió.
- El diagnóstico previo ahora informa si el comando `yazi` está disponible.
- La validación incluye `yazi` entre los comandos requeridos.
- README, guía rápida y documentación específica actualizados con instalación,
  uso, actualización, compatibilidad y resolución de problemas.

## 10.0.0

- Proyecto preparado para publicación en GitHub.
- README completo en español y captura actualizada del resultado final.
- Galería del diseño actual y la versión anterior dentro del README.
- Instalador adaptado para familias Arch, Debian y Fedora.
- CachyOS permanece como plataforma principal.
- Instalación de paquetes consciente de la distribución.
- Powerlevel10k y complementos Zsh portables mediante repositorios Git.
- Rotación automática de cualquier PNG presente en el directorio de imágenes.
- Nuevo panel Fastfetch «Hardware» con Host, placa, CPU y temperatura, RAM,
  Zram, discos, GPU, OpenGL, Vulkan y pantallas.
- Colores RGB ajustados a la especificación oficial de Dracula.
- Perfiles Fastfetch adaptativos según el ancho y alto de la terminal.
- Imágenes aleatorias siempre visibles y proporcionadas en tamaños `10×5`,
  `14×7` y `18×9` celdas.
- Fila decorativa de Pac-Man y fantasmas con colores Dracula.
- Citas aleatorias recortadas al ancho disponible para evitar contenido
  desordenado o cortado.
- Tamaño inicial de las ventanas de Ghostty establecido en 109×22 celdas.
- Validación de los tres perfiles con sustitución de imágenes aleatorias.
- Reinstalación limpia imágenes antiguas después de respaldarlas.
- Documentación completa de atajos, paquetes, seguridad y restauración.
- Licencia MIT para scripts y documentación.
- Documento separado para licencias de recursos gráficos.
