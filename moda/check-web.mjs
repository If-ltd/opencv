import assert from 'node:assert/strict'
import { resolve } from 'node:path'
import { pathToFileURL } from 'node:url'

const artifact = pathToFileURL(resolve(process.argv[2]))
globalThis.self = { location: artifact }
globalThis.importScripts = () => {
  throw new Error('The OpenCV module must load without importScripts')
}

const { default: createOpenCv } = await import(artifact)
const cv = await createOpenCv()
for (const name of ['imread', 'cvtColor', 'threshold', 'findContours', 'contourArea', 'approxPolyDP', 'inpaint']) {
  assert.equal(typeof cv[name], 'function', `Missing OpenCV browser binding: ${name}`)
}

const input = new cv.Mat(1, 5, cv.CV_32FC1, new cv.Scalar(0))
const result = new cv.Mat()
try {
  input.floatPtr(0, 2)[0] = 1
  cv.GaussianBlur(input, result, new cv.Size(3, 3), 1)
  const data = result.floatPtr(0)
  assert.ok(data[1] > 0 && data[2] > data[1] && data[1] === data[3])
} finally {
  input.delete()
  result.delete()
}
