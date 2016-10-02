(ns odr.queries
  (:require [yesql.core :refer [defqueries]]
            [environ.core :refer [env]]))

(defn db-spec
  []
  (env :database-url (str "postgres:///" (env :user)))
  ;; {:classname "org.postgresql.Driver"
  ;;  :subprotocol "postgresql"
  ;;  :subname "//ec2-54-75-233-22.eu-west-1.compute.amazonaws.com:5432/deusuk15alttgt"
  ;;  :user "jpmgdunmufbyva"
  ;;  :password "O0BA4MmdlBEekOSyB6Ljxb6vEF"
  ;;  :sslmode "require"}
  )

(defqueries "odr/queries.sql" {:connection (db-spec)})

(defn parse-party-line []
  (let [pl (partyline)]
    (zipmap (map (fn [x] [(:id_hlasovani x) (:pohlavi x)])
                 pl)
            (map :vysledek pl))))

(defn gurgle [[person votes]]
  (conj person (zipmap (map :id_hlasovani votes) (map :vysledek votes))))

(defn compliance [[first last party votes] party-line]
  (let [x (reduce (fn [[cnt good] [hlasovani vysledek]]
                    [(inc cnt) (if (= vysledek (party-line [hlasovani party]))
                                 (inc good)
                                 good)])
                  [0.0 0.0]
                  (seq  votes))]
    (Math/round (* 100 (/ (x 1) (x 0))))))

(defn votes-by-person []
  (let [votes (person-votes)
        by-person (group-by (fn [x] (mapv x [:jmeno :prijmeni :pohlavi]))
                            votes)
        gurgled (map gurgle by-person)
        pl (parse-party-line)]
    (map #(conj (pop %) (compliance % pl)) gurgled)))
