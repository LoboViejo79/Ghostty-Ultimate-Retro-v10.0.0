# Integración de Yazi

Ghostty Ultimate Retro integra [Yazi](https://yazi-rs.github.io/) como gestor
de archivos para terminal. La integración incluye instalación, actualización,
diagnóstico, validación y un wrapper para Zsh.

## Instalar o actualizar

Ejecuta el menú desde la raíz del proyecto:

```bash
bash iniciar.sh
```

La opción **2) Instalar solo paquetes faltantes** instala Yazi cuando no está
presente. La opción **11) Instalar o actualizar Yazi** permite gestionarlo de
forma independiente.

Según la distribución se utiliza:

- `pacman` en Arch Linux, CachyOS, EndeavourOS y Manjaro.
- `apt` en Debian, Ubuntu y derivadas.
- `dnf` en Fedora, RHEL y derivadas.
- Snap como alternativa en Debian/Fedora cuando Yazi no está en los
  repositorios habilitados y `snap` ya se encuentra disponible.

El script también instala `file`, dependencia necesaria para detectar tipos de
archivo. Todas las instalaciones y actualizaciones solicitan confirmación.

## Activar la integración de Zsh

La opción **3) Aplicar o reinstalar configuraciones** copia el wrapper a
`~/.zshrc`. Abre una terminal nueva o recarga la configuración:

```bash
source ~/.zshrc
```

## Uso

Ejecuta:

```bash
y
```

Puedes pasar argumentos normales de Yazi, por ejemplo `y ~/Descargas`.

- `q` cierra Yazi y deja Zsh en el directorio que estabas visitando.
- `Q` cierra Yazi sin cambiar el directorio de Zsh.
- `F1` o `~` abre la ayuda de Yazi.

El comando `yazi` continúa disponible para iniciar el programa sin el wrapper.

## Cómo funciona el wrapper

La función `y` crea un archivo temporal y se lo entrega a Yazi mediante
`--cwd-file`. Al cerrar, lee el directorio guardado, cambia a él cuando
corresponde y elimina el archivo temporal. Esta implementación sigue el
wrapper recomendado en la documentación oficial de Yazi.

## Comprobación

Desde el menú principal:

- **1) Diagnóstico previo** muestra si `yazi` está en `PATH`.
- **5) Validar instalación actual** comprueba que `yazi`, Zsh y Git estén
  disponibles, además del resto de las configuraciones.

También puedes comprobarlo manualmente:

```bash
yazi --version
type y
```

## Solución de problemas

Si `y` no existe, aplica nuevamente la configuración con la opción 3 y abre
otra terminal o ejecuta `source ~/.zshrc`.

Si el instalador no encuentra Yazi, revisa que los repositorios de tu sistema
estén habilitados. En sistemas compatibles puede ofrecer Snap; de lo contrario,
consulta la [guía oficial de instalación](https://yazi-rs.github.io/docs/installation/).

Si las vistas previas no reconocen los tipos de archivo, comprueba `file`:

```bash
file --version
```

## Referencias

- [Instalación oficial](https://yazi-rs.github.io/docs/installation/)
- [Inicio rápido y wrapper para shell](https://yazi-rs.github.io/docs/quick-start/)
