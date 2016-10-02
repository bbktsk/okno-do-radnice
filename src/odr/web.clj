(ns odr.web
  (:require [clojure.java.io :as io]
            [clojure.java.jdbc :as db]
            [clojure.walk :refer [keywordize-keys]]
            [compojure.core :refer [defroutes GET PUT POST DELETE ANY context]]
            [compojure.route :as route]
            [crypto.random :as random]
            [environ.core :refer [env]]
            [liberator.core :refer [resource defresource]]
            [liberator.dev :refer [wrap-trace]]
            [ring.adapter.jetty :as jetty]
            [ring.middleware.cookies :only [wrap-cookies]]
            [ring.middleware.defaults :refer :all]
            [ring.middleware.json :refer [wrap-json-response wrap-json-body]]
            [ring.middleware.cors :refer [wrap-cors]]
            [slingshot.slingshot :refer [throw+]]
            [yesql.core :refer [defqueries]]
            [net.cgrand.enlive-html :as enlive]
            [odr.templates :as tpl]
            [odr.queries :as q]))


(def types-html ["text/html"])

(defn show [tpl & args]
  (apply str (apply tpl args)))

(defn handle-index []
  (let [sums (q/testsumby)
        count (-> (q/testcount) first :count)
        x (map :name sums)
        y (map :sum sums)
        data {"x" x, "y" y}]
    (show tpl/index count data)))

(defn handle-presence []
  (let [data (q/presence)]
    (show tpl/presence data)))

(defroutes app
  (GET "/index.html" [] (handle-index))
  (GET "/dash/presence.html" [] (handle-presence))

  ;;(context "/api" []
           ;; (POST "/users"
           ;;       {body :body}
           ;;       (r-user-create (keywordize-keys body)))
           ;; (PUT "/users/:id"
           ;;       {{id :id} :params body :body}
           ;;       (r-user-update id (keywordize-keys body)))
           ;;(POST "/users/:id/visit"
           ;;      {{id :id} :params body :body}
           ;;      (r-user-visit id (keywordize-keys body)))
           ;;)

  ;;(route/resources "/")
  (ANY "*" []
       (route/not-found (slurp (io/resource "404.html")))))


(defn -main [& [port]]
  (let [port (Integer. (or port (env :port) 5000))]
    (jetty/run-jetty (-> #'app
                         (wrap-cors :access-control-allow-origin [#".*"]
                                    :access-control-allow-methods [:get :put :post :delete])
                         (wrap-trace :header :ui)
                         ;;wrap-json-response
                         ;;wrap-json-body
                         (wrap-defaults (assoc site-defaults :security {:anti-forgery false}))
                         )
                     {:port port :join? false})))

;; For interactive development:
;; (.stop server)
;; (def server (-main))
