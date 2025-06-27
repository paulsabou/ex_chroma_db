defmodule ExChromaDbTest do
  @moduledoc false

  use ExUnit.Case, async: false

  setup do
    # Code to run before each test
    {:ok, true} = ExChromaDb.reset()
    # Code to run after each test
    on_exit(fn ->
      nil
    end)

    :ok
  end

  describe "can connect to ChromaDB and retrieve info" do
    test "returns the healthcheck" do
      {:ok, true} = ExChromaDb.healthcheck()
    end

    test "returns the heartbeat" do
      {:ok, heartbeat} = ExChromaDb.heartbeat()
      assert heartbeat > 0
    end

    test "returns the version" do
      {:ok, version} = ExChromaDb.version()
      assert version =~ "1.0.0"
    end
  end

  describe "can manage tenants in ChromaDB" do
    test "create a tenants with valid name" do
      tenant_name = "exchroma#{Enum.random(1..1000)}"
      {:error, _} = ExChromaDb.get_tenant(tenant_name)
      {:ok, tenant_name} = ExChromaDb.create_tenant(tenant_name)
      {:ok, true} = ExChromaDb.get_tenant(tenant_name)
    end

    test "cannot create a tenants with invalid name" do
      tenant_name = ""
      {:error, _} = ExChromaDb.create_tenant(tenant_name)
    end
  end

  describe "can manage databases in ChromaDB" do
    test "create a database with valid name" do
      {tenant_name, _database_name, _collection_name} = random_tenant_database_collection_name()
      {:error, _} = ExChromaDb.get_tenant(tenant_name)
      {:ok, tenant_name} = ExChromaDb.create_tenant(tenant_name)

      database_name = "db_exchroma#{Enum.random(1..1000)}"

      {:error, _} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, true} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})
    end

    test "cannot create a databases with invalid name" do
      {tenant_name, _database_name, _collection_name} = random_tenant_database_collection_name()
      {:ok, _} = ExChromaDb.create_tenant(tenant_name)

      invalid_database_name = ""

      {:error, _} =
        ExChromaDb.create_database(%{
          tenant_name: tenant_name,
          database_name: invalid_database_name
        })
    end

    test "delete a database with valid name" do
      {tenant_name, database_name, _collection_name} = random_tenant_database_collection_name()
      {:error, _} = ExChromaDb.get_tenant(tenant_name)
      {:ok, tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:error, _} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, _} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, true} =
        ExChromaDb.delete_database(%{tenant_name: tenant_name, database_name: database_name})

      {:error, _} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})
    end

    test "cannot delete an nonexistent database" do
      {tenant_name, database_name, _collection_name} = random_tenant_database_collection_name()
      {:error, _} = ExChromaDb.get_tenant(tenant_name)
      {:ok, tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:error, _} =
        ExChromaDb.get_database(%{tenant_name: tenant_name, database_name: database_name})

      {:error, _} =
        ExChromaDb.delete_database(%{tenant_name: tenant_name, database_name: database_name})
    end

    test "list databases" do
      {tenant_name, _database_name, _collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      # There are no databases yet
      {:ok, []} = ExChromaDb.list_databases(tenant_name)

      {:ok, "database_1"} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: "database_1"})

      {:ok, "database_2"} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: "database_2"})

      {:ok, databases} = ExChromaDb.list_databases(tenant_name)
      assert length(databases) == 2

      assert Enum.all?(databases, fn database ->
               database["name"] in ["database_1", "database_2"]
             end)
    end

    test "count collections in database" do
      {tenant_name, _database_name, _collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      database_info = %{tenant_name: tenant_name, database_name: "database_1"}

      {:ok, "database_1"} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: "database_1"})

      {:ok, 0} = ExChromaDb.count_collections(database_info)

      {:ok, "collection_1"} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: "database_1",
          collection_name: "collection_1"
        })

      {:ok, 1} = ExChromaDb.count_collections(database_info)

      {:ok, "collection_2"} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: "database_1",
          collection_name: "collection_2"
        })

      {:ok, 2} = ExChromaDb.count_collections(database_info)
    end
  end

  describe "can manage collections in ChromaDB" do
    test "create a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()
      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })
    end

    test "cannot create a collection with invalid name" do
      {tenant_name, database_name, _collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      {:error, _} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: ""
        })
    end

    test "cannot delete nonexistent collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      {:error, _} =
        ExChromaDb.get_collection_info(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })

      {:error, _} =
        ExChromaDb.delete_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })

      {:ok, true} =
        ExChromaDb.delete_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })

      {:error, _} =
        ExChromaDb.get_collection_info(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: collection_name
        })
    end

    test "list collections" do
      {tenant_name, database_name, _collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      # There are no collections yet
      {:ok, []} =
        ExChromaDb.list_collections(%{tenant_name: tenant_name, database_name: database_name})

      {:ok, "collection_1"} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: "collection_1"
        })

      {:ok, "collection_2"} =
        ExChromaDb.create_collection(%{
          tenant_name: tenant_name,
          database_name: database_name,
          collection_name: "collection_2"
        })

      {:ok, collections} =
        ExChromaDb.list_collections(%{tenant_name: tenant_name, database_name: database_name})

      assert length(collections) == 2

      assert Enum.all?(collections, fn collection ->
               collection["name"] in ["collection_1", "collection_2"]
             end)
    end

    test "add records to a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()

      # Can add records to an existing collection
      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1"}, %{metadata_2: "metadata_2"}],
            uris: ["uri_1", "uri_2"]
          }
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)
    end

    test "delete records by id in a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1"}, %{metadata_2: "metadata_2"}],
            uris: ["uri_1", "uri_2"]
          }
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      # Can delete all records from a collection
      {:ok, true} =
        ExChromaDb.collection_records_delete_by_ids(
          collection_info_with_name,
          [id1]
        )

      {:ok, 1} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_delete_by_ids(
          collection_info_with_name,
          [id2]
        )

      {:ok, 0} =
        ExChromaDb.collection_records_count(collection_info_with_name)
    end

    test "add and delete records by metas to a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()

      id3 = UUID.uuid4()
      id4 = UUID.uuid4()

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1"}, %{metadata_2: "metadata_2"}],
            uris: ["uri_1", "uri_2"]
          }
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_3", "document_4"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id3, id4],
            metadatas: [%{metadata_3: "metadata_3"}, %{metadata_4: "metadata_4"}],
            uris: ["uri_3", "uri_4"]
          }
        )

      {:ok, 4} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_delete_by_metas(
          collection_info_with_name,
          %{"metadata_1" => "metadata_1"}
        )

      {:ok, 3} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_delete_by_metas(
          collection_info_with_name,
          %{"metadata_2" => "metadata_2"}
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_delete_by_metas(
          collection_info_with_name,
          %{"metadata_3" => "metadata_3"}
        )

      {:ok, 1} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_delete_by_metas(
          collection_info_with_name,
          %{"metadata_4" => "metadata_4"}
        )

      {:ok, 0} =
        ExChromaDb.collection_records_count(collection_info_with_name)
    end

    test "add and update records in a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()
      id3 = UUID.uuid4()

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1"}, %{metadata_2: "metadata_2"}],
            uris: ["uri_1", "uri_2"]
          }
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_upsert(
          collection_info_with_name,
          %{
            documents: ["document_3"],
            embeddings: [[1, 2, 3]],
            ids: [id3],
            metadatas: [%{metadata_3: "metadata_3"}],
            uris: ["uri_3"]
          }
        )

      {:ok, 3} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, true} =
        ExChromaDb.collection_records_update(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [1, 2, 3]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1_updated"}, %{metadata_2: "metadata_2_updated"}],
            uris: ["uri_1_updated", "uri_2_updated"]
          }
        )

      {:ok, 3} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, response} =
        ExChromaDb.collection_records_get(
          collection_info_with_name,
          %{
            include: ["documents", "embeddings", "metadatas", "uris"]
          }
        )

      assert response.documents == ["document_1", "document_2", "document_3"]
      assert response.embeddings == [[1, 2, 3], [1, 2, 3], [1, 2, 3]]
      assert response.ids == [id1, id2, id3]

      assert response.metadatas == [
               %{"metadata_1" => "metadata_1_updated"},
               %{"metadata_2" => "metadata_2_updated"},
               %{"metadata_3" => "metadata_3"}
             ]

      assert response.uris == ["uri_1_updated", "uri_2_updated", "uri_3"]
    end

    test "get records from a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2"],
            embeddings: [[1, 2, 3], [4, 5, 6]],
            ids: [id1, id2],
            metadatas: [%{metadata_1: "metadata_1"}, %{metadata_2: "metadata_2"}],
            uris: ["uri_1", "uri_2"]
          }
        )

      {:ok, 2} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, response} =
        ExChromaDb.collection_records_get(
          collection_info_with_name,
          %{
            include: ["documents", "embeddings", "metadatas", "uris"],
            ids: [id1, id2]
          }
        )

      assert response.documents == ["document_1", "document_2"]
      assert response.embeddings == [[1, 2, 3], [4, 5, 6]]
      assert response.ids == [id1, id2]

      assert response.metadatas == [
               %{"metadata_1" => "metadata_1"},
               %{"metadata_2" => "metadata_2"}
             ]

      assert response.uris == ["uri_1", "uri_2"]
    end

    test "add and query records in a collection" do
      {tenant_name, database_name, collection_name} = random_tenant_database_collection_name()

      {:ok, ^tenant_name} = ExChromaDb.create_tenant(tenant_name)

      {:ok, ^database_name} =
        ExChromaDb.create_database(%{tenant_name: tenant_name, database_name: database_name})

      collection_info_with_name = %{
        tenant_name: tenant_name,
        database_name: database_name,
        collection_name: collection_name
      }

      {:ok, ^collection_name} =
        ExChromaDb.create_collection(collection_info_with_name)

      id1 = UUID.uuid4()
      id2 = UUID.uuid4()
      id3 = UUID.uuid4()

      {:ok, true} =
        ExChromaDb.collection_records_add(
          collection_info_with_name,
          %{
            documents: ["document_1", "document_2", "document_3"],
            embeddings: [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
            ids: [id1, id2, id3],
            metadatas: [
              %{metadata_1: "metadata_1"},
              %{metadata_2: "metadata_2"},
              %{metadata_3: "metadata_3"}
            ],
            uris: ["uri_1", "uri_2", "uri_3"]
          }
        )

      {:ok, 3} =
        ExChromaDb.collection_records_count(collection_info_with_name)

      {:ok, response1} =
        ExChromaDb.collection_records_query(
          collection_info_with_name,
          %{
            include: ["documents", "embeddings", "metadatas", "uris"],
            n_results: 2,
            query_embeddings: [[1, 2, 3]]
          }
        )

      assert response1.documents == [["document_1", "document_2"]]

      {:ok, response2} =
        ExChromaDb.collection_records_get(
          collection_info_with_name,
          %{
            include: ["documents", "embeddings", "metadatas", "uris"],
            where: %{metadata_2: "metadata_2"}
          }
        )

      assert response2.documents == ["document_2"]
    end
  end

  defp random_tenant_database_collection_name() do
    tenant_name = "exchroma#{Enum.random(1..1000)}"
    database_name = "db_exchroma#{Enum.random(1..1000)}"
    collection_name = "coll_exchroma#{Enum.random(1..1000)}"

    {tenant_name, database_name, collection_name}
  end
end
