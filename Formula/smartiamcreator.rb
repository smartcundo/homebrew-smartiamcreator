require 'formula'

class Smartiamcreator < Formula
  homepage 'https://github.com/smartcundo/smartiamcreator'
  url 'https://github.com/smartcundo/homebrew-smartiamcreator.git'
  version '0.0.1'

  def install
    Language::Python.each_python(build) do |python, version|
      ENV.prepend_create_path "PATH", buildpath/"vendor/bin"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"vendor/lib/python#{version}/site-packages"
      resource("cython").stage do
        system python, *Language::Python.setup_install_args(buildpath/"vendor")
      end

      bundle_path = libexec/"lib/python#{version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", bundle_path
      resource("six").stage do
        system python, *Language::Python.setup_install_args(libexec)
      end
      (lib/"python#{version}/site-packages/homebrew-h5py-bundle.pth").write "#{bundle_path}\n"

      args = Language::Python.setup_install_args(prefix)
      args << "configure"
      args << "--hdf5=#{Formula["homebrew/science/hdf5"].opt_prefix}"
      args << "--mpi" if build.with? :mpi

      ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
      system python, *args
    end
  end
end

