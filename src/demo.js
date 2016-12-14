const glslify = require('glslify')

import {
  WebGLRenderer,
  Clock,
  Vector2,
  PerspectiveCamera,
  Scene,
  ShaderMaterial,
  Color,
  Vector3,
  FlatShading,
  IcosahedronBufferGeometry,
  Mesh
} from 'three'
// import dat from 'dat-gui'
import Stats from 'stats-js'
import EffectComposer from './post-processing/EffectComposer'
import ShaderPass from './post-processing/ShaderPass'
import RenderPass from './post-processing/RenderPass'
//

// const OrbitControls = require('three-orbit-controls')(THREE);

class Demo {
  constructor (args) {
    this.startStats()
    this.updateBinded = this.update.bind(this)
    // this.startGUI();

    // this.md = new MobileDetect(window.navigator.userAgent)

    this.renderer = null
    this.camera = null
    this.scene = null
    this.counter = 0
    this.clock = new Clock()

    this.start()
  }

  start () {
    this.createRender()
    this.createScene()
    // this.addComposer()
    this.addObjects()
    this.onResize()
    this.update()
  }

  startStats () {
    this.stats = new Stats()
    this.stats.domElement.style.position = 'absolute'
    this.stats.domElement.style.display = 'none'
    this.stats.domElement.style.top = 0
    this.stats.domElement.style.left = 0
    document.body.appendChild(this.stats.domElement)
  }

  createRender () {
    this.renderer = new WebGLRenderer({
      antialias: true,
      depth: true
    })

    this.renderer.setClearColor(0x000000)
    this.renderer.setClearAlpha(0)
    this.renderer.setPixelRatio(window.devicePixelRatio || 1)
    this.renderer.setSize(window.innerWidth, window.innerHeight)
    this.renderer.gammaInput = true
    this.renderer.gammaOuput = true
    this.renderer.autoClear = false

    document.querySelector('.canvas-container').appendChild(this.renderer.domElement)
  }

  addComposer () {
    this.composer = new EffectComposer(this.renderer)

    let scenePass = new RenderPass(this.scene, this.camera, false, 0x000000, 0)

    this.gamma = {
      uniforms: {
        tDiffuse: { type: 't', value: null },
        time: { type: 'f', value: 0 },
        resolution: {
          type: 'v2',
          value: new Vector2(
            window.innerWidth * (window.devicePixelRatio || 1),
            window.innerHeight * (window.devicePixelRatio || 1)
          )}
      },
      vertexShader: glslify('./post-processing/glsl/screen_vert.glsl'),
      fragmentShader: glslify('./post-processing/glsl/gamma.glsl')
    }

    /*
    passes
    */

    this.composer.addPass(scenePass)

    this.gammaShader = new ShaderPass(this.gamma)
    this.gammaShader.renderToScreen = true
    this.composer.addPass(this.gammaShader)
  }

  createScene () {
    this.camera = new PerspectiveCamera(1000, window.innerWidth / window.innerHeight, 0.01, 4000)
    this.camera.position.set(0, 0, 0)

    // this.controls = new OrbitControls(this.camera, this.renderer.domElement);
    // this.controls.maxDistance = 500;

    this.scene = new Scene()
  }

  addObjects () {
    // ref for next update
    // http://www.shutterstock.com/video/clip-21724933-stock-footage-abstract-d-rendering-of-kinked-and-bended-lines-camera-moving-through-the-massive-of-thin-lines.html?src=rel/5868443:7/3p

    this.material = new ShaderMaterial({
      uniforms: {
        time: {type: 'f', value: 0},
        ambient: {type: 'c', value: new Color(0x171717)},
        specular: {type: 'c', value: new Color(0x030303)},
        color: {type: 'c', value: new Color(0xCCCCCC)},
        shininess: {type: 'f', value: 0.2},
        lightDirection: {type: 'v3', value: new Vector3(0, 0, 0)}
      },
      vertexShader: glslify('./glsl/material-vert.glsl'),
      fragmentShader: glslify('./glsl/material-frag.glsl'),
      shading: FlatShading,
      side: 1,
      wireframe: true
    })

    this.form = new IcosahedronBufferGeometry(120, 4)
    this.mesh = new Mesh(this.form, this.material)

    this.scene.add(this.mesh)
  }

  startGUI () {
    // var gui = new dat.GUI()
    // gui.add(camera.position, 'x', 0, 400)
    // gui.add(camera.position, 'y', 0, 400)
    // gui.add(camera.position, 'z', 0, 400)
  }

  update () {
    this.stats.begin()

    let el = this.clock.getElapsedTime() * 0.5
    // let d = this.clock.getDelta()

    this.renderer.clear()

    // this.renderer.render(this.scene, this.camera);

    this.mesh.rotation.y += 0.0007
    this.mesh.rotation.x += 0.0007
    this.mesh.rotation.z += 0.0007
    // this.mapTexture.offset.x += 10.0115;
    // this.mapTexture.offset.y += 10.0115;
    // this.mapTexture.needsUpdate = true;

    this.material.uniforms.time.value = el
    // this.gammaShader.uniforms.time.value = el

    // if(!this.md.mobile())
    // {
    //     // this.gammaShader.uniforms.time.value = el;
    //     // this.composer.render(d);
    // } else {
    // }

    this.renderer.render(this.scene, this.camera)

    // this.composer.render()

    this.stats.end()
    window.requestAnimationFrame(this.updateBinded)
  }

  onResize () {
    this.renderer.setSize(window.innerWidth, window.innerHeight)
    // this.composer.setSize(window.innerWidth, window.innerHeight)
    this.camera.aspect = window.innerWidth / window.innerHeight
    this.camera.updateProjectionMatrix()
  }
}

export default Demo
