(import [flask [Flask render_template]]
        [flask_jsonrpc [JSONRPC]]
        [os.path :as _p])

;; flask debug mode workaround.
;; without this, it will silently fail to run the reloader
;; see https://github.com/hylang/hy/issues/329
(import sys)
(setv sys.executable "hy")

(def app (Flask __name__))
(def jsonrpc (JSONRPC app "/rpc"))

(with-decorator
  (jsonrpc.method "App.index")
  (defn rpc_index []
    "hello from server"))

(with-decorator
  (app.route "/")
  (defn index []
    (render_template "index.html")))

;; note the .hy file must be explicitly included into extra_files
(defmain [&rest args]
  (setv app.root_path (_p.abspath (_p.dirname __file__)))
  (app.run :debug True
           :extra_files [__file__]))

