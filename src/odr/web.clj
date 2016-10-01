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

(defn db-spec
  []
  (env :database-url (str "postgres:///" (env :user))))

(def types-html ["text/html"])

(defresource index []
  :available-media-types types-html
  :allowed-methods [:get]
  :handle-ok (fn [_] index))

(defn show [tpl & args]
  (apply str (apply tpl args)))

(defroutes app
  (GET "/index.html" [] (show tpl/index (:count (first (q/testcount)))))

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
