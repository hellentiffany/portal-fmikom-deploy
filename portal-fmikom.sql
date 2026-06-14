-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 08, 2026 at 11:56 AM
-- Server version: 8.4.3
-- PHP Version: 8.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `portal-fmikom`
--

-- --------------------------------------------------------

--
-- Table structure for table `absensi_magangs`
--

CREATE TABLE `absensi_magangs` (
  `id` bigint UNSIGNED NOT NULL,
  `pendaftaran_id` bigint UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `waktu_masuk` time DEFAULT NULL,
  `waktu_keluar` time DEFAULT NULL,
  `latitude_masuk` decimal(10,8) DEFAULT NULL,
  `longitude_masuk` decimal(11,8) DEFAULT NULL,
  `latitude_keluar` decimal(10,8) DEFAULT NULL,
  `longitude_keluar` decimal(11,8) DEFAULT NULL,
  `lokasi_valid` tinyint(1) NOT NULL DEFAULT '0',
  `foto_bukti_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-244bed0e05563a2c1ad506d706b342d3', 'i:1;', 1780908029),
('laravel-cache-244bed0e05563a2c1ad506d706b342d3:timer', 'i:1780908029;', 1780908029),
('laravel-cache-4bc8a7e73c73785805d294977595bcd4', 'i:1;', 1780906846),
('laravel-cache-4bc8a7e73c73785805d294977595bcd4:timer', 'i:1780906846;', 1780906846),
('laravel-cache-60d1394dfc7ae8a0cf8cee2559c49570', 'i:1;', 1780906826),
('laravel-cache-60d1394dfc7ae8a0cf8cee2559c49570:timer', 'i:1780906826;', 1780906826),
('laravel-cache-8668a6d2b73af29e8c016c171a4b3379', 'i:1;', 1780894090),
('laravel-cache-8668a6d2b73af29e8c016c171a4b3379:timer', 'i:1780894090;', 1780894090),
('laravel-cache-f06274183fa3d0c5751d4260f152c15d', 'i:1;', 1780909295),
('laravel-cache-f06274183fa3d0c5751d4260f152c15d:timer', 'i:1780909295;', 1780909295),
('laravel-cache-notif_count_pending_admin', 'i:0;', 1780916034),
('laravel-cache-tgs:kode_fakultas_nomor_surat', 's:10:\"Ybk.041.10\";', 1780910008),
('laravel-cache-tgs:kode_prefix_nomor_surat', 's:1:\"B\";', 1780910008);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_respons`
--

CREATE TABLE `detail_respons` (
  `id` bigint UNSIGNED NOT NULL,
  `respons_id` bigint UNSIGNED NOT NULL,
  `pertanyaan_id` bigint UNSIGNED NOT NULL,
  `pilihan_id` bigint UNSIGNED DEFAULT NULL,
  `jawaban_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fakultas`
--

CREATE TABLE `fakultas` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `fakultas`
--

INSERT INTO `fakultas` (`id`, `nama`, `kode`, `created_at`, `updated_at`) VALUES
(1, 'FMIKOM', 'FMIKOM', '2026-06-07 17:55:45', '2026-06-07 17:55:45');

-- --------------------------------------------------------

--
-- Table structure for table `jenis_surats`
--

CREATE TABLE `jenis_surats` (
  `id` bigint UNSIGNED NOT NULL,
  `category_id` bigint UNSIGNED DEFAULT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kode_surat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kode_klasifikasi` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `field_config` json DEFAULT NULL,
  `template_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `template_surat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `allowed_role_id` bigint UNSIGNED DEFAULT NULL,
  `approval_role_id` bigint UNSIGNED DEFAULT NULL,
  `perlu_approval` tinyint(1) NOT NULL DEFAULT '1',
  `qr_mode` enum('immediate','after_approval') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'after_approval' COMMENT 'immediate=QR langsung aktif, after_approval=setelah disetujui',
  `allowed_roles` json DEFAULT NULL COMMENT 'Array slug role yang boleh buat surat ini, null=semua',
  `urutan` smallint UNSIGNED NOT NULL DEFAULT '0',
  `alur_pengajuan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'submission',
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jenis_surats`
--

INSERT INTO `jenis_surats` (`id`, `category_id`, `nama`, `slug`, `kode_surat`, `kode_klasifikasi`, `deskripsi`, `field_config`, `template_file_path`, `template_surat`, `created_at`, `updated_at`, `allowed_role_id`, `approval_role_id`, `perlu_approval`, `qr_mode`, `allowed_roles`, `urutan`, `alur_pengajuan`, `is_active`) VALUES
(21, 4, 'Surat Undangan PKL', 'surat-undangan-pkl-1780825154', NULL, 'SU', NULL, '[{\"help\": \"\", \"name\": \"nama\", \"type\": \"text\", \"label\": \"Nama\", \"options\": [], \"required\": true, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"nim\", \"type\": \"text\", \"label\": \"NIM\", \"options\": [], \"required\": true, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"prodi\", \"type\": \"text\", \"label\": \"Prodi\", \"options\": [], \"required\": true, \"placeholder\": \"\"}]', NULL, NULL, '2026-06-07 09:39:14', '2026-06-07 10:59:09', 3, 7, 1, 'after_approval', NULL, 0, 'submission', 1),
(23, 1, 'Surat Permohonan Dispensasi', 'surat-permohonan-dispensasi-1780825792', NULL, 'PU', NULL, '[{\"help\": \"\", \"name\": \"hari_tanggal\", \"type\": \"text\", \"label\": \"Hari/Tanggal\", \"options\": [], \"required\": true, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"waktu\", \"type\": \"text\", \"label\": \"Waktu\", \"options\": [], \"required\": true, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"tempat\", \"type\": \"text\", \"label\": \"Tempat\", \"options\": [], \"required\": true, \"placeholder\": \"\"}]', NULL, NULL, '2026-06-07 09:49:52', '2026-06-07 10:02:08', 4, 6, 1, 'after_approval', NULL, 0, 'submission', 1),
(24, 4, 'Surat Undangan Makan', 'surat-undangan-makan-1780826061', NULL, 'MU', NULL, '[{\"help\": \"\", \"name\": \"hari_tanggal\", \"type\": \"text\", \"label\": \"Hari/Tanggal\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"waktu\", \"type\": \"text\", \"label\": \"Waktu\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"tempat\", \"type\": \"text\", \"label\": \"Tempat\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}]', NULL, NULL, '2026-06-07 09:54:21', '2026-06-08 08:14:41', 5, 6, 1, 'after_approval', NULL, 0, 'submission', 1),
(25, 2, 'Surat Keterangan Lulus', 'surat-keterangan-lulus-1780848158', NULL, 'KL', NULL, '[{\"help\": \"\", \"name\": \"tahun_lulus\", \"type\": \"text\", \"label\": \"Tahun Lulus\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"tempat_tanggal_lahir\", \"type\": \"text\", \"label\": \"Tempat/Tanggal Lahir\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}]', NULL, NULL, '2026-06-07 16:02:38', '2026-06-08 00:52:40', 4, 7, 1, 'after_approval', NULL, 0, 'submission', 1),
(26, 1, 'Surat Permohonan Cuti Mahasiswa', 'surat-permohonan-cuti-mahasiswa-1780851970', NULL, 'CM', NULL, '[{\"help\": \"\", \"name\": \"semester\", \"type\": \"text\", \"label\": \"Semester\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}, {\"help\": \"\", \"name\": \"alasan_cuti\", \"type\": \"text\", \"label\": \"Alasan Cuti\", \"options\": [], \"required\": true, \"add_label\": \"Tambah\", \"item_label\": \"Item\", \"repeatable\": false, \"placeholder\": \"\"}]', NULL, NULL, '2026-06-07 17:06:10', '2026-06-08 03:22:58', 3, 7, 1, 'after_approval', NULL, 0, 'submission', 1),
(27, 1, 'Surat Permohonan Cuti', 'surat-permohonan-cuti-1780909679', NULL, 'KU', NULL, '[]', NULL, NULL, '2026-06-08 09:07:59', '2026-06-08 09:09:30', 5, 7, 1, 'after_approval', NULL, 0, 'submission', 1);

-- --------------------------------------------------------

--
-- Table structure for table `jenis_surat_roles`
--

CREATE TABLE `jenis_surat_roles` (
  `id` bigint UNSIGNED NOT NULL,
  `jenis_surat_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `queue` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `karir_alumnis`
--

CREATE TABLE `karir_alumnis` (
  `id` bigint UNSIGNED NOT NULL,
  `alumni_id` bigint UNSIGNED NOT NULL,
  `nama_perusahaan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `jabatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bidang_industri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kota` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `negara` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Indonesia',
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date DEFAULT NULL,
  `gaji_range` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_kerja` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_current` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kuesioners`
--

CREATE TABLE `kuesioners` (
  `id` bigint UNSIGNED NOT NULL,
  `pembuat_id` bigint UNSIGNED NOT NULL,
  `judul` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `periode_mulai` date NOT NULL,
  `periode_selesai` date NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'draft',
  `tujuan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `logbook_magangs`
--

CREATE TABLE `logbook_magangs` (
  `id` bigint UNSIGNED NOT NULL,
  `pendaftaran_id` bigint UNSIGNED NOT NULL,
  `tanggal` date NOT NULL,
  `aktivitas_harian` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kompetensi_dicapai` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `catatan_dosen` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lowongan_infos`
--

CREATE TABLE `lowongan_infos` (
  `id` bigint UNSIGNED NOT NULL,
  `pembuat_id` bigint UNSIGNED NOT NULL,
  `judul` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_perusahaan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `poster_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_eksternal` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_14_170933_add_two_factor_columns_to_users_table', 1),
(5, '2026_03_29_180950_create_roles_table', 1),
(6, '2026_03_29_180951_create_fakultas_table', 1),
(7, '2026_03_29_180954_create_program_studis_table', 1),
(8, '2026_03_29_180955_create_perusahaan_mitras_table', 1),
(9, '2026_03_29_180956_create_pembimbing_lapangans_table', 1),
(10, '2026_03_29_180958_create_jenis_surats_table', 1),
(11, '2026_03_29_181000_create_surats_table', 1),
(12, '2026_03_29_181003_create_surat_approval_flows_table', 1),
(13, '2026_03_29_181004_create_surat_lampirans_table', 1),
(14, '2026_03_29_181005_create_pendaftaran_magangs_table', 1),
(15, '2026_03_29_181007_create_absensi_magangs_table', 1),
(16, '2026_03_29_181007_create_logbook_magangs_table', 1),
(17, '2026_03_29_181008_create_penilaian_magangs_table', 1),
(18, '2026_03_29_181009_create_profil_alumnis_table', 1),
(19, '2026_03_29_181010_create_karir_alumnis_table', 1),
(20, '2026_03_29_181011_create_kuesioners_table', 1),
(21, '2026_03_29_181012_create_pertanyaan_kuesioners_table', 1),
(22, '2026_03_29_181013_create_pilihan_jawabans_table', 1),
(23, '2026_03_29_181013_create_respons_kuesioners_table', 1),
(24, '2026_03_29_181014_create_detail_respons_table', 1),
(25, '2026_03_29_181015_create_lowongan_infos_table', 1),
(26, '2026_03_29_181016_add_columns_to_users_table', 1),
(27, '2026_03_29_201237_add_otp_and_password_changed_to_users_table', 2),
(28, '2026_03_29_214305_add_registration_fields_to_users_table', 3),
(29, '2026_04_10_084236_add_fields_to_jenis_surats_table', 4),
(30, '2026_04_10_084935_add_qr_token_to_surats_table', 4),
(31, '2026_04_14_110300_add_tanggal_kebutuhan_to_surats_table', 5),
(32, '2026_04_15_052519_create_jenis_surat_roles_table', 6),
(33, '2026_04_15_054253_create_surat_data_table', 7),
(34, '2026_04_15_055204_add_perlu_approval_to_jenis_surats_table', 8),
(35, '2026_04_18_120000_add_field_config_to_jenis_surats_table', 9),
(36, '2026_04_20_060000_add_workflow_columns_to_surat_approval_flows_table', 10),
(37, '2026_04_27_130000_create_surat_categories_table', 11),
(38, '2026_04_27_130100_add_category_fields_to_jenis_surats_table', 11),
(39, '2026_04_27_140000_create_surat_templates_table', 12),
(40, '2026_04_27_140100_create_surat_template_placeholders_table', 12),
(41, '2026_04_27_140200_add_generated_document_fields_to_surats_table', 12),
(42, '2026_04_28_110000_add_api_workflow_fields_to_surats_and_jenis_surats_table', 13),
(43, '2026_05_03_000001_enhance_surat_system', 14),
(44, '2026_05_21_141205_add_generated_by_and_qr_validated_at_to_surats_table', 15),
(45, '2026_06_05_000000_add_indexes_to_surats_table', 15),
(46, '2026_06_05_000000_remove_super_admin_and_user_roles', 15),
(47, '2026_06_05_100000_seed_role_accounts', 15),
(48, '2026_06_06_180000_add_kode_klasifikasi_to_jenis_surats_table', 15),
(49, '2026_06_07_120000_sync_template_placeholders_and_fix_letter_templates', 16),
(50, '2026_06_07_140000_fix_surat_keterangan_lulus_field_contract', 16);

-- --------------------------------------------------------

--
-- Table structure for table `nomor_surat_sequences`
--

CREATE TABLE `nomor_surat_sequences` (
  `id` bigint UNSIGNED NOT NULL,
  `kode_surat` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Kode jenis surat, e.g. CUTI-MHS',
  `tahun` smallint UNSIGNED NOT NULL,
  `bulan` smallint UNSIGNED NOT NULL,
  `urutan` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nomor_surat_sequences`
--

INSERT INTO `nomor_surat_sequences` (`id`, `kode_surat`, `tahun`, `bulan`, `urutan`, `created_at`, `updated_at`) VALUES
(1, 'FAKULTAS-2026', 2026, 0, 45, '2026-06-06 04:10:27', '2026-06-08 09:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`email`, `token`, `created_at`) VALUES
('muchlisinmaruf@gmail.com', '$2y$12$HV9sEnOHXdFBzBUffbISwuXVa2VHXeovZmgdJs1wFWRtymE.sKsJS', '2026-03-29 15:11:55'),
('tiffanyhellen27@gmail.com', '$2y$12$BydpmQHppo7K8kWVv1wlYeQXW/2LpHVWT1YapiSdfa5SaYmNXnXYa', '2026-04-08 08:22:15');

-- --------------------------------------------------------

--
-- Table structure for table `pembimbing_lapangans`
--

CREATE TABLE `pembimbing_lapangans` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `perusahaan_id` bigint UNSIGNED NOT NULL,
  `jabatan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pendaftaran_magangs`
--

CREATE TABLE `pendaftaran_magangs` (
  `id` bigint UNSIGNED NOT NULL,
  `mahasiswa_id` bigint UNSIGNED NOT NULL,
  `perusahaan_id` bigint UNSIGNED NOT NULL,
  `dosen_pembimbing_id` bigint UNSIGNED DEFAULT NULL,
  `pembimbing_lapangan_id` bigint UNSIGNED DEFAULT NULL,
  `surat_tugas_id` bigint UNSIGNED DEFAULT NULL,
  `tanggal_mulai` date NOT NULL,
  `tanggal_selesai` date NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `penilaian_magangs`
--

CREATE TABLE `penilaian_magangs` (
  `id` bigint UNSIGNED NOT NULL,
  `pendaftaran_id` bigint UNSIGNED NOT NULL,
  `dosen_id` bigint UNSIGNED DEFAULT NULL,
  `pembimbing_lapangan_id` bigint UNSIGNED DEFAULT NULL,
  `nilai_logbook` decimal(5,2) DEFAULT NULL,
  `nilai_presentasi` decimal(5,2) DEFAULT NULL,
  `nilai_dari_pembimbing` decimal(5,2) DEFAULT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT NULL,
  `catatan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tanggal_nilai` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pertanyaan_kuesioners`
--

CREATE TABLE `pertanyaan_kuesioners` (
  `id` bigint UNSIGNED NOT NULL,
  `kuesioner_id` bigint UNSIGNED NOT NULL,
  `teks_pertanyaan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `urutan` int NOT NULL DEFAULT '0',
  `wajib_diisi` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `perusahaan_mitras`
--

CREATE TABLE `perusahaan_mitras` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `kota` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `radius_valid_meter` decimal(10,2) DEFAULT NULL,
  `bidang_industri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kontak_person` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telepon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pilihan_jawabans`
--

CREATE TABLE `pilihan_jawabans` (
  `id` bigint UNSIGNED NOT NULL,
  `pertanyaan_id` bigint UNSIGNED NOT NULL,
  `teks_pilihan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nilai` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `profil_alumnis`
--

CREATE TABLE `profil_alumnis` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `program_studi_id` bigint UNSIGNED NOT NULL,
  `nim` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tahun_lulus` int NOT NULL,
  `no_telepon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linkedin_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `program_studis`
--

CREATE TABLE `program_studis` (
  `id` bigint UNSIGNED NOT NULL,
  `fakultas_id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `program_studis`
--

INSERT INTO `program_studis` (`id`, `fakultas_id`, `nama`, `kode`, `created_at`, `updated_at`) VALUES
(1, 1, 'Informatika', 'IF', '2026-06-07 17:55:45', '2026-06-07 17:55:45');

-- --------------------------------------------------------

--
-- Table structure for table `respons_kuesioners`
--

CREATE TABLE `respons_kuesioners` (
  `id` bigint UNSIGNED NOT NULL,
  `kuesioner_id` bigint UNSIGNED NOT NULL,
  `alumni_id` bigint UNSIGNED NOT NULL,
  `is_complete` tinyint(1) NOT NULL DEFAULT '0',
  `tanggal_isi` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `nama`, `slug`, `deskripsi`, `created_at`, `updated_at`) VALUES
(3, 'Mahasiswa', 'mahasiswa', 'Pengguna mahasiswa untuk layanan akademik FAST.', '2026-04-18 04:24:26', '2026-04-18 04:24:26'),
(4, 'Dosen', 'dosen', 'Pengguna dosen untuk layanan akademik FAST.', '2026-04-18 04:24:26', '2026-04-18 04:24:26'),
(5, 'Admin', 'admin', 'Pengelola validasi administrasi surat FAST.', '2026-04-18 04:24:26', '2026-04-18 04:24:26'),
(6, 'Kaprodi', 'kaprodi', 'Pemberi persetujuan surat tingkat program studi.', '2026-04-22 17:06:37', '2026-04-22 17:06:37'),
(7, 'Dekan', 'dekan', 'Pemberi persetujuan surat tingkat fakultas.', '2026-04-22 17:06:37', '2026-04-22 17:06:37');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('otZ68116UEwamMF0Pc3XslmbbfTsZZxlQViKpBf6', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'YTo1OntzOjY6Il90b2tlbiI7czo0MDoiNUxRczBWMU5QWFhtZEp0OXoxQnFxeE1qVm5RTUJtVndPeEVINlpNcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDg6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9hZG1pbi90ZW1wbGF0ZXMvMTIvcHJldmlldyI7czo1OiJyb3V0ZSI7czoyMzoiYWRtaW4udGVtcGxhdGVzLnByZXZpZXciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjUwOiJsb2dpbl93ZWJfNTliYTM2YWRkYzJiMmY5NDAxNTgwZjAxNGM3ZjU4ZWE0ZTMwOTg5ZCI7aTo1O3M6MzoidXJsIjthOjE6e3M6ODoiaW50ZW5kZWQiO3M6Mzk6Imh0dHA6Ly9sb2NhbGhvc3Q6ODAwMC9zZXR0aW5ncy9zZWN1cml0eSI7fX0=', 1777883984);

-- --------------------------------------------------------

--
-- Table structure for table `surats`
--

CREATE TABLE `surats` (
  `id` bigint UNSIGNED NOT NULL,
  `jenis_surat_id` bigint UNSIGNED NOT NULL,
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pengajuan',
  `pemohon_id` bigint UNSIGNED NOT NULL,
  `nomor_surat` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keperluan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `kepada_yth` json DEFAULT NULL COMMENT 'Array penerima surat, bisa multiple',
  `lampiran_keterangan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Contoh: 1 (satu) lembar',
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `isi_surat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `admin_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rejection_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `validated_by_admin_id` bigint UNSIGNED DEFAULT NULL,
  `validated_by_admin_at` datetime DEFAULT NULL,
  `approved_by_id` bigint UNSIGNED DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `generated_file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generated_file_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `generated_at` datetime DEFAULT NULL,
  `generated_by` bigint UNSIGNED DEFAULT NULL,
  `qr_validated_at` timestamp NULL DEFAULT NULL COMMENT 'Waktu pertama kali QR di-scan dan surat sudah divalidasi',
  `template_version` int UNSIGNED DEFAULT NULL,
  `revisi_ke` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `catatan_revisi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `print_count` smallint UNSIGNED NOT NULL DEFAULT '0',
  `last_printed_at` timestamp NULL DEFAULT NULL,
  `rendered_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tanggal_pengajuan` datetime DEFAULT NULL,
  `tanggal_kebutuhan` date DEFAULT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `qr_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surats`
--

INSERT INTO `surats` (`id`, `jenis_surat_id`, `type`, `pemohon_id`, `nomor_surat`, `keperluan`, `kepada_yth`, `lampiran_keterangan`, `status`, `isi_surat`, `admin_note`, `rejection_reason`, `validated_by_admin_id`, `validated_by_admin_at`, `approved_by_id`, `approved_at`, `generated_file_path`, `generated_file_type`, `generated_at`, `generated_by`, `qr_validated_at`, `template_version`, `revisi_ke`, `catatan_revisi`, `print_count`, `last_printed_at`, `rendered_snapshot`, `tanggal_pengajuan`, `tanggal_kebutuhan`, `tanggal_selesai`, `created_at`, `updated_at`, `qr_token`) VALUES
(162, 26, 'pengajuan', 18, NULL, 'keperluan cuti', NULL, NULL, 'rejected_admin', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"keperluan cuti\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"8 (delapan)\",\"alasan_cuti\":\"Bekerja untuk melunasi biaya\"}}', NULL, 'lampirkan surat keterangan aktif', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 11:23:10', '2026-06-08', NULL, '2026-06-08 04:23:10', '2026-06-08 04:25:58', NULL),
(163, 26, 'pengajuan', 18, 'B/041/Ybk.041.10/CM/2026', 'Mau bekerja memabntu ekonomi keluarga', NULL, NULL, 'finished', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"Mau bekerja memabntu ekonomi keluarga\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"2 (dua)\",\"alasan_cuti\":\"Membantu orang tua\"}}', NULL, NULL, 5, '2026-06-08 11:38:32', NULL, NULL, 'fast/generated/surat-163-surat-permohonan-cuti-mahasiswa-1780851970.pdf', 'pdf', '2026-06-08 11:39:45', 20, NULL, 1, 0, NULL, 0, NULL, '<section style=\"margin-bottom: 8px; text-align: center;\">\n    <img src=\"data:image/png;base64,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\" alt=\"Logo\" style=\"display:block; height:70px; margin:0 auto 4px;\">\n    <div style=\"color: #1B5E20; font-family: \'Times New Roman\', serif; font-weight: 700; line-height: 1.1; text-align: center;\">\n        <div style=\"font-size: 16pt; letter-spacing: 0.08em;\">UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP</div>\n        <div style=\"font-size: 13pt; text-transform: uppercase;\">FAKULTAS MATEMATIKA DAN ILMU KOMPUTER</div><div style=\"font-size: 13pt;\">(FMIKOM)</div>\n    </div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; line-height: 1.2; margin: 3px 0 5px; text-align: center;\">Keputusan Kemendikbud RI Nomor : 264/E/O/2014 Tanggal 23 Juli 2014</p>\n    <div style=\"margin: 0 auto; width: 100%;\">\n        <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n        <div style=\"border-top: 0.8px solid #1B5E20;\"></div>\n    </div>\n</section>\n<div class=\"surat-content\"><h2 style=\"margin: 0 0 2px 0; text-align: center; font-size: 12pt; font-weight: bold; text-decoration: underline; text-decoration-thickness: 2px; text-transform: uppercase;\">PERMOHONAN CUTI MAHASISWA</h2>\n<p style=\"margin: 0 0 10px 0; text-align: center; font-size: 11pt;\">Nomor: B/041/Ybk.041.10/CM/2026</p>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   \">Yang bertanda tangan di bawah ini:</p>\n<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 11pt;\">\n<tbody>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Nama</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Hellen Tiffani</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">NIM</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">22EO10001</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Program Studi</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Informatika</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Semester</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">2 (dua)</td>\n            </tr>\n</tbody>\n</table>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 11pt; line-height: 1.5;   \">Dengan ini mengajukan permohonan cuti, dengan alasan dikarenakan Membantu orang tua.</p>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 11pt; line-height: 1.5;   \">Demikian Surat yang saya buat, terimakasih</p>\n</div>\n<!-- <div style=\"position: fixed; bottom: 3mm; left: 0; right: 0; width: 100%;\"> -->\n    <div style=\"width: 100%;\">\n    <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n    <div style=\"border-top: 0.8px solid #1B5E20; margin-bottom: 3px;\"></div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; font-weight: 700; text-align: center; margin: 0; line-height: 1.3; letter-spacing: 0.04em; font-family: \'Times New Roman\', serif;\">\n        UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Jl. Kemerdekaan Barat No. 17, Cilacap Tengah, http:// unugha.ac.id\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Email : fmikom@unugha.ac.id Telp. : (0282) 695415, 695407 Fax : (0282) 695407\n    </p>\n</div>', '2026-06-08 11:37:06', '2026-06-08', '2026-06-08 11:39:45', '2026-06-08 04:37:06', '2026-06-08 04:39:52', '1fb5f0de-3f13-44ef-b977-7f9a9f853202'),
(164, 25, 'pengajuan', 21, NULL, 'Untuk syarat S2', NULL, NULL, 'cancelled', '{\"jenis_surat_id\":25,\"jenis_surat\":\"Surat Keterangan Lulus\",\"keperluan\":\"Untuk syarat S2\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"tahun_lulus\":\"2028\",\"tempat_tanggal_lahir\":\"Cilacap, 20 Maret 2022\"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 11:45:31', '2026-06-08', NULL, '2026-06-08 04:45:31', '2026-06-08 04:47:23', NULL),
(165, 24, 'surat_keluar', 5, 'B/042/Ybk.041.10/MU/2026', 'Makan besar', NULL, NULL, 'finished', '{\"jenis_surat_id\":24,\"jenis_surat\":\"Surat Undangan Makan\",\"keperluan\":\"Makan besar\",\"data\":{\"hari_tanggal\":\"Senin, 09 Januari 2000\",\"waktu\":\"10.00 s.d selesai\",\"tempat\":\"Curug\",\"perihal\":\"Makan bersama keluarga FMIKOM\",\"lampiran_keterangan\":\"1\",\"kepada_yth\":[\"Dekan FMIKOM\"]},\"created_by\":{\"id\":5,\"name\":\"Admin\"}}', NULL, NULL, 5, '2026-06-08 15:13:36', NULL, NULL, 'fast/generated/surat-165-surat-undangan-makan-1780826061.pdf', 'pdf', '2026-06-08 15:13:30', 5, NULL, 4, 0, NULL, 0, NULL, '<section style=\"margin-bottom: 8px; text-align: center;\">\n    <img src=\"data:image/png;base64,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\" alt=\"Logo\" style=\"display:block; height:70px; margin:0 auto 4px;\">\n    <div style=\"color: #1B5E20; font-family: \'Times New Roman\', serif; font-weight: 700; line-height: 1.1; text-align: center;\">\n        <div style=\"font-size: 16pt; letter-spacing: 0.08em;\">UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP</div>\n        <div style=\"font-size: 13pt; text-transform: uppercase;\">FAKULTAS MATEMATIKA DAN ILMU KOMPUTER</div><div style=\"font-size: 13pt;\">(FMIKOM)</div>\n    </div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; line-height: 1.2; margin: 3px 0 5px; text-align: center;\">Keputusan Kemendikbud RI Nomor : 264/E/O/2014 Tanggal 23 Juli 2014</p>\n    <div style=\"margin: 0 auto; width: 100%;\">\n        <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n        <div style=\"border-top: 0.8px solid #1B5E20;\"></div>\n    </div>\n</section>\n<div class=\"surat-content\"><table style=\"width: 100%; border-collapse: collapse; margin-bottom: 14px; font-size: 12pt; line-height: 1.7;\">\n    <tbody>\n        <tr>\n            <td style=\"width: 55%; vertical-align: top; padding: 0;\">\n                <table style=\"border-collapse: collapse; font-size: 12pt;\">\n                    <tr>\n                        <td style=\"width: 80px; padding: 0; vertical-align: top;\">Nomor</td>\n                        <td style=\"width: 16px; padding: 0 4px; vertical-align: top; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">B/042/Ybk.041.10/MU/2026</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Lampiran</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">1</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Perihal</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">Makan bersama keluarga FMIKOM</td>\n                    </tr>\n                </table>\n            </td>\n            <td style=\"width: 45%; vertical-align: top; text-align: right; padding: 0; font-size: 12pt;\">\n                Cilacap, 08 Juni 2026\n            </td>\n        </tr>\n    </tbody>\n</table><div style=\"margin-bottom: 12px; font-size: 12pt; line-height: 1.6;\">\n    <p style=\"margin: 0; font-size: 12pt;\">Yth. Dekan FMIKOM</p>\n\n    <p style=\"margin: 0; font-size: 12pt;\">di-</p>\n    <p style=\"margin: 0 0 0 20px; font-size: 12pt;\">Tempat</p>\n</div><p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   text-indent: 20px;\">Sehubungan dengan adanya kegiatan Ceremonial Kelulusan Sarjana Strata Satu Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap, yang akan dilaksanakan pada</p>\n<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 11pt;\">\n<tbody>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Hari/Tanggal</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Senin, 09 Januari 2000</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Waktu</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">10.00 s.d selesai</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Tempat</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Curug</td>\n            </tr>\n</tbody>\n</table>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   \">Maka kami dari Fakultas Matematika dan Ilmu Komputer UNUGHA Cilacap bermaksud mohon ijin kepada Bapak/Ibu Dosen untuk mahasiswa kami atas nama Gita Wahyuni guna mengikuti kegiatan tersebut.</p>\n</div>\n<!-- <div style=\"position: fixed; bottom: 3mm; left: 0; right: 0; width: 100%;\"> -->\n    <div style=\"width: 100%;\">\n    <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n    <div style=\"border-top: 0.8px solid #1B5E20; margin-bottom: 3px;\"></div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; font-weight: 700; text-align: center; margin: 0; line-height: 1.3; letter-spacing: 0.04em; font-family: \'Times New Roman\', serif;\">\n        UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Jl. Kemerdekaan Barat No. 17, Cilacap Tengah, http:// unugha.ac.id\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Email : fmikom@unugha.ac.id Telp. : (0282) 695415, 695407 Fax : (0282) 695407\n    </p>\n</div>', '2026-06-08 15:13:28', NULL, '2026-06-08 15:13:30', '2026-06-08 08:13:28', '2026-06-08 08:13:36', '9125d8bc-c481-4ab7-b7f9-b30ae548645e');
INSERT INTO `surats` (`id`, `jenis_surat_id`, `type`, `pemohon_id`, `nomor_surat`, `keperluan`, `kepada_yth`, `lampiran_keterangan`, `status`, `isi_surat`, `admin_note`, `rejection_reason`, `validated_by_admin_id`, `validated_by_admin_at`, `approved_by_id`, `approved_at`, `generated_file_path`, `generated_file_type`, `generated_at`, `generated_by`, `qr_validated_at`, `template_version`, `revisi_ke`, `catatan_revisi`, `print_count`, `last_printed_at`, `rendered_snapshot`, `tanggal_pengajuan`, `tanggal_kebutuhan`, `tanggal_selesai`, `created_at`, `updated_at`, `qr_token`) VALUES
(166, 24, 'surat_keluar', 5, 'B/043/Ybk.041.10/MU/2026', 'makan besar', NULL, NULL, 'finished', '{\"jenis_surat_id\":24,\"jenis_surat\":\"Surat Undangan Makan\",\"keperluan\":\"makan besar\",\"data\":{\"hari_tanggal\":\"Senin, 10 Mei 2002\",\"waktu\":\"10.00 s.d selesai\",\"tempat\":\"In the home\",\"perihal\":\"Makan bersama\",\"lampiran_keterangan\":\"1\",\"kepada_yth\":[\"Ketua Program Studi Informatika\"]},\"created_by\":{\"id\":5,\"name\":\"Admin\"}}', NULL, NULL, 5, '2026-06-08 15:16:00', NULL, NULL, 'fast/generated/surat-166-surat-undangan-makan-1780826061.pdf', 'pdf', '2026-06-08 15:17:05', 19, NULL, 4, 0, NULL, 0, NULL, '<section style=\"margin-bottom: 8px; text-align: center;\">\n    <img src=\"data:image/png;base64,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\" alt=\"Logo\" style=\"display:block; height:70px; margin:0 auto 4px;\">\n    <div style=\"color: #1B5E20; font-family: \'Times New Roman\', serif; font-weight: 700; line-height: 1.1; text-align: center;\">\n        <div style=\"font-size: 16pt; letter-spacing: 0.08em;\">UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP</div>\n        <div style=\"font-size: 13pt; text-transform: uppercase;\">FAKULTAS MATEMATIKA DAN ILMU KOMPUTER</div><div style=\"font-size: 13pt;\">(FMIKOM)</div>\n    </div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; line-height: 1.2; margin: 3px 0 5px; text-align: center;\">Keputusan Kemendikbud RI Nomor : 264/E/O/2014 Tanggal 23 Juli 2014</p>\n    <div style=\"margin: 0 auto; width: 100%;\">\n        <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n        <div style=\"border-top: 0.8px solid #1B5E20;\"></div>\n    </div>\n</section>\n<div class=\"surat-content\"><table style=\"width: 100%; border-collapse: collapse; margin-bottom: 14px; font-size: 12pt; line-height: 1.7;\">\n    <tbody>\n        <tr>\n            <td style=\"width: 55%; vertical-align: top; padding: 0;\">\n                <table style=\"border-collapse: collapse; font-size: 12pt;\">\n                    <tr>\n                        <td style=\"width: 80px; padding: 0; vertical-align: top;\">Nomor</td>\n                        <td style=\"width: 16px; padding: 0 4px; vertical-align: top; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">B/043/Ybk.041.10/MU/2026</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Lampiran</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">1</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Perihal</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">Makan bersama</td>\n                    </tr>\n                </table>\n            </td>\n            <td style=\"width: 45%; vertical-align: top; text-align: right; padding: 0; font-size: 12pt;\">\n                Cilacap, 08 Juni 2026\n            </td>\n        </tr>\n    </tbody>\n</table><div style=\"margin-bottom: 12px; font-size: 12pt; line-height: 1.6;\">\n    <p style=\"margin: 0; font-size: 12pt;\">Yth. Ketua Program Studi Informatika</p>\n\n    <p style=\"margin: 0; font-size: 12pt;\">di-</p>\n    <p style=\"margin: 0 0 0 20px; font-size: 12pt;\">Tempat</p>\n</div><p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   text-indent: 20px;\">Sehubungan dengan adanya kegiatan Ceremonial Kelulusan Sarjana Strata Satu Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap, yang akan dilaksanakan pada</p>\n<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 11pt;\">\n<tbody>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Hari/Tanggal</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Senin, 10 Mei 2002</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Waktu</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">10.00 s.d selesai</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Tempat</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">In the home</td>\n            </tr>\n</tbody>\n</table>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   \">Maka kami dari Fakultas Matematika dan Ilmu Komputer UNUGHA Cilacap bermaksud mohon ijin kepada Bapak/Ibu Dosen untuk mahasiswa kami atas nama Gita Wahyuni guna mengikuti kegiatan tersebut.</p>\n</div>\n<!-- <div style=\"position: fixed; bottom: 3mm; left: 0; right: 0; width: 100%;\"> -->\n    <div style=\"width: 100%;\">\n    <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n    <div style=\"border-top: 0.8px solid #1B5E20; margin-bottom: 3px;\"></div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; font-weight: 700; text-align: center; margin: 0; line-height: 1.3; letter-spacing: 0.04em; font-family: \'Times New Roman\', serif;\">\n        UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Jl. Kemerdekaan Barat No. 17, Cilacap Tengah, http:// unugha.ac.id\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Email : fmikom@unugha.ac.id Telp. : (0282) 695415, 695407 Fax : (0282) 695407\n    </p>\n</div>', '2026-06-08 15:16:00', NULL, '2026-06-08 15:17:05', '2026-06-08 08:16:00', '2026-06-08 08:17:06', '067b449f-ec4e-4cdc-8c24-fdadc8d84d0b'),
(167, 21, 'surat_keluar', 5, 'B/044/Ybk.041.10/SU/2026', 'Untuk penempatan PKL', NULL, NULL, 'revision_requested', '{\"jenis_surat_id\":21,\"jenis_surat\":\"Surat Undangan PKL\",\"keperluan\":\"Untuk penempatan PKL\",\"data\":{\"nama\":\"Hellen Tiffani\",\"nim\":\"22527812\",\"prodi\":\"Informatika\",\"perihal\":\"Penempatan Lokasi PKL\",\"lampiran_keterangan\":\"1\",\"kepada_yth\":[\"Ketua Program Studi Informatika\"]},\"created_by\":{\"id\":5,\"name\":\"Admin\"}}', NULL, NULL, 5, '2026-06-08 15:19:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 'Kurang pas', 0, NULL, '<section style=\"margin-bottom: 8px; text-align: center;\">\n    <img src=\"data:image/png;base64,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\" alt=\"Logo\" style=\"display:block; height:70px; margin:0 auto 4px;\">\n    <div style=\"color: #1B5E20; font-family: \'Times New Roman\', serif; font-weight: 700; line-height: 1.1; text-align: center;\">\n        <div style=\"font-size: 16pt; letter-spacing: 0.08em;\">UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP</div>\n        <div style=\"font-size: 13pt; text-transform: uppercase;\">FAKULTAS MATEMATIKA DAN ILMU KOMPUTER</div><div style=\"font-size: 13pt;\">(FMIKOM)</div>\n    </div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; line-height: 1.2; margin: 3px 0 5px; text-align: center;\">Keputusan Kemendikbud RI Nomor : 264/E/O/2014 Tanggal 23 Juli 2014</p>\n    <div style=\"margin: 0 auto; width: 100%;\">\n        <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n        <div style=\"border-top: 0.8px solid #1B5E20;\"></div>\n    </div>\n</section>\n<div class=\"surat-content\"><table style=\"width: 100%; border-collapse: collapse; margin-bottom: 14px; font-size: 12pt; line-height: 1.7;\">\n    <tbody>\n        <tr>\n            <td style=\"width: 55%; vertical-align: top; padding: 0;\">\n                <table style=\"border-collapse: collapse; font-size: 12pt;\">\n                    <tr>\n                        <td style=\"width: 80px; padding: 0; vertical-align: top;\">Nomor</td>\n                        <td style=\"width: 16px; padding: 0 4px; vertical-align: top; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">B/044/Ybk.041.10/SU/2026</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Lampiran</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">1</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Perihal</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">Penempatan Lokasi PKL</td>\n                    </tr>\n                </table>\n            </td>\n            <td style=\"width: 45%; vertical-align: top; text-align: right; padding: 0; font-size: 12pt;\">\n                Cilacap, 08 Juni 2026\n            </td>\n        </tr>\n    </tbody>\n</table><div style=\"margin-bottom: 12px; font-size: 12pt; line-height: 1.6;\">\n    <p style=\"margin: 0; font-size: 12pt;\">Yth. Ketua Program Studi Informatika</p>\n\n    <p style=\"margin: 0; font-size: 12pt;\">di-</p>\n    <p style=\"margin: 0 0 0 20px; font-size: 12pt;\">Tempat</p>\n</div><p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   text-indent: 20px;\">Salam silaturahmi dan sejahtera kami sampaikan semoga kita senantiasa mendapatkan ridlo dan pertolongan dari Allah SWT dalam menjalankan aktivitas sehari-hari. Amin.</p>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   text-indent: 20px;\">Sehubungan dengan tuntutan kebutuhan mahasiswa untuk mendapatkan pengalaman nyata di lapangan, maka Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap menugaskan kepada mahasiswa kami:	</p>\n<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 12pt;\">\n<tbody>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Nama</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">Admin</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">NIM</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">22527812</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Prodi</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\"></td>\n            </tr>\n</tbody>\n</table>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   \">Untuk mengadakan riset terkait dengan skripsi yang sedang di kerjakan dengan Judul “Sistem Informasi Tata Kelola Arsip Lembaga Dokumen Pemasyarakatan Kelas IIA Gladakan Nusakambangan Berbasis Website”. Berkenaan dengan hal tersebut, maka kami mengajukan permohonan kepada Bapak/Ibu Kepala Lembaga Pemasyarakatan Kelas IIA Gladakan Nusakambangan Cilacap untuk mengizinkan mahasiswa kami melaksanakan kegiatan tersebut</p>\n<div style=\"font-size: 10.5pt; line-height: 1.4; margin-top: 8px;\">\n<p style=\"margin: 0 0 2px 0;\">Tembusan:</p>\n<p style=\"margin: 0;\">1. Ka. Prodi</p>\n<p style=\"margin: 0;\">2. Bagian Akademik</p>\n</div>\n</div>\n<!-- <div style=\"position: fixed; bottom: 3mm; left: 0; right: 0; width: 100%;\"> -->\n    <div style=\"width: 100%;\">\n    <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n    <div style=\"border-top: 0.8px solid #1B5E20; margin-bottom: 3px;\"></div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; font-weight: 700; text-align: center; margin: 0; line-height: 1.3; letter-spacing: 0.04em; font-family: \'Times New Roman\', serif;\">\n        UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Jl. Kemerdekaan Barat No. 17, Cilacap Tengah, http:// unugha.ac.id\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Email : fmikom@unugha.ac.id Telp. : (0282) 695415, 695407 Fax : (0282) 695407\n    </p>\n</div>', '2026-06-08 15:19:13', NULL, NULL, '2026-06-08 08:19:13', '2026-06-08 08:20:21', NULL);
INSERT INTO `surats` (`id`, `jenis_surat_id`, `type`, `pemohon_id`, `nomor_surat`, `keperluan`, `kepada_yth`, `lampiran_keterangan`, `status`, `isi_surat`, `admin_note`, `rejection_reason`, `validated_by_admin_id`, `validated_by_admin_at`, `approved_by_id`, `approved_at`, `generated_file_path`, `generated_file_type`, `generated_at`, `generated_by`, `qr_validated_at`, `template_version`, `revisi_ke`, `catatan_revisi`, `print_count`, `last_printed_at`, `rendered_snapshot`, `tanggal_pengajuan`, `tanggal_kebutuhan`, `tanggal_selesai`, `created_at`, `updated_at`, `qr_token`) VALUES
(168, 26, 'pengajuan', 18, NULL, 'rerwr3t432r2r222', NULL, NULL, 'cancelled', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"rerwr3t432r2r222\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"5\",\"alasan_cuti\":\"egt4y4y\"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 15:43:05', '2026-06-08', NULL, '2026-06-08 08:43:05', '2026-06-08 08:43:45', NULL),
(169, 26, 'pengajuan', 18, NULL, 'uuuuuuuuuuuuuuuu', NULL, NULL, 'cancelled', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"uuuuuuuuuuuuuuuu\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"8\",\"alasan_cuti\":\"aaaaaaaaaaaaaaaaaaa\"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 15:46:36', '2026-06-08', NULL, '2026-06-08 08:46:36', '2026-06-08 08:47:06', NULL),
(170, 26, 'pengajuan', 18, NULL, 'uuuuuuuuuuuuuuuuuuuuuuu', NULL, NULL, 'cancelled', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"uuuuuuuuuuuuuuuuuuuuuuu\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"7\",\"alasan_cuti\":\"aaaaaaaaaaaaaaaaaaa\"}}', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 15:55:00', '2026-06-08', NULL, '2026-06-08 08:55:00', '2026-06-08 08:55:26', NULL),
(171, 26, 'pengajuan', 18, NULL, 'Untuk keperluan izin cuti', NULL, NULL, 'rejected_admin', '{\"jenis_surat_id\":26,\"jenis_surat\":\"Surat Permohonan Cuti Mahasiswa\",\"keperluan\":\"Untuk keperluan izin cuti\",\"tanggal_kebutuhan\":\"2026-06-08\",\"data\":{\"semester\":\"6 (enam)\",\"alasan_cuti\":\"Karena kerjaaaa\"}}', NULL, 'jbji', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, NULL, '2026-06-08 16:00:19', '2026-06-08', NULL, '2026-06-08 09:00:19', '2026-06-08 09:04:44', NULL),
(172, 24, 'surat_keluar', 5, 'B/045/Ybk.041.10/MU/2026', 'yyyyyyyyyyyyyyy', NULL, NULL, 'validated_admin', '{\"jenis_surat_id\":24,\"jenis_surat\":\"Surat Undangan Makan\",\"keperluan\":\"yyyyyyyyyyyyyyy\",\"data\":{\"hari_tanggal\":\"56 ht\",\"waktu\":\"67 wib\",\"tempat\":\"gigiu\",\"perihal\":\"uuuuuuuuuuu\",\"lampiran_keterangan\":\"1\",\"kepada_yth\":[\"Dekan FMIKOM\"]},\"created_by\":{\"id\":5,\"name\":\"Admin\"}}', NULL, NULL, 5, '2026-06-08 16:06:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, 0, NULL, 0, NULL, '<section style=\"margin-bottom: 8px; text-align: center;\">\n    <img src=\"data:image/png;base64,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\" alt=\"Logo\" style=\"display:block; height:70px; margin:0 auto 4px;\">\n    <div style=\"color: #1B5E20; font-family: \'Times New Roman\', serif; font-weight: 700; line-height: 1.1; text-align: center;\">\n        <div style=\"font-size: 16pt; letter-spacing: 0.08em;\">UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP</div>\n        <div style=\"font-size: 13pt; text-transform: uppercase;\">FAKULTAS MATEMATIKA DAN ILMU KOMPUTER</div><div style=\"font-size: 13pt;\">(FMIKOM)</div>\n    </div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; line-height: 1.2; margin: 3px 0 5px; text-align: center;\">Keputusan Kemendikbud RI Nomor : 264/E/O/2014 Tanggal 23 Juli 2014</p>\n    <div style=\"margin: 0 auto; width: 100%;\">\n        <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n        <div style=\"border-top: 0.8px solid #1B5E20;\"></div>\n    </div>\n</section>\n<div class=\"surat-content\"><table style=\"width: 100%; border-collapse: collapse; margin-bottom: 14px; font-size: 12pt; line-height: 1.7;\">\n    <tbody>\n        <tr>\n            <td style=\"width: 55%; vertical-align: top; padding: 0;\">\n                <table style=\"border-collapse: collapse; font-size: 12pt;\">\n                    <tr>\n                        <td style=\"width: 80px; padding: 0; vertical-align: top;\">Nomor</td>\n                        <td style=\"width: 16px; padding: 0 4px; vertical-align: top; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">B/045/Ybk.041.10/MU/2026</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Lampiran</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">1</td>\n                    </tr>\n                    <tr>\n                        <td style=\"padding: 0; vertical-align: top;\">Perihal</td>\n                        <td style=\"padding: 0; text-align: center;\">:</td>\n                        <td style=\"padding: 0;\">uuuuuuuuuuu</td>\n                    </tr>\n                </table>\n            </td>\n            <td style=\"width: 45%; vertical-align: top; text-align: right; padding: 0; font-size: 12pt;\">\n                Cilacap, 08 Juni 2026\n            </td>\n        </tr>\n    </tbody>\n</table><div style=\"margin-bottom: 12px; font-size: 12pt; line-height: 1.6;\">\n    <p style=\"margin: 0; font-size: 12pt;\">Yth. Dekan FMIKOM</p>\n\n    <p style=\"margin: 0; font-size: 12pt;\">di-</p>\n    <p style=\"margin: 0 0 0 20px; font-size: 12pt;\">Tempat</p>\n</div><p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   text-indent: 20px;\">Sehubungan dengan adanya kegiatan Ceremonial Kelulusan Sarjana Strata Satu Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap, yang akan dilaksanakan pada</p>\n<table style=\"width: 100%; border-collapse: collapse; margin-bottom: 8px; font-size: 11pt;\">\n<tbody>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Hari/Tanggal</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">56 ht</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Waktu</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">67 wib</td>\n            </tr>\n<tr>\n                <td style=\"width: 130px; padding: 1.5px 0; vertical-align: top;\">Tempat</td>\n                <td style=\"width: 12px; padding: 1.5px 0; vertical-align: top; text-align: center;\">:</td>\n                <td style=\"padding: 1.5px 0; vertical-align: top;\">gigiu</td>\n            </tr>\n</tbody>\n</table>\n<p style=\"margin: 0 0 8px 0; text-align: justify; font-size: 12pt; line-height: 1.5;   \">Maka kami dari Fakultas Matematika dan Ilmu Komputer UNUGHA Cilacap bermaksud mohon ijin kepada Bapak/Ibu Dosen untuk mahasiswa kami atas nama Gita Wahyuni guna mengikuti kegiatan tersebut.</p>\n</div>\n<!-- <div style=\"position: fixed; bottom: 3mm; left: 0; right: 0; width: 100%;\"> -->\n    <div style=\"width: 100%;\">\n    <div style=\"border-top: 2px solid #1B5E20; margin-bottom: 1.5px;\"></div>\n    <div style=\"border-top: 0.8px solid #1B5E20; margin-bottom: 3px;\"></div>\n    <p style=\"color: #1B5E20; font-size: 9.5pt; font-weight: 700; text-align: center; margin: 0; line-height: 1.3; letter-spacing: 0.04em; font-family: \'Times New Roman\', serif;\">\n        UNIVERSITAS NAHDLATUL ULAMA AL GHAZALI CILACAP\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Jl. Kemerdekaan Barat No. 17, Cilacap Tengah, http:// unugha.ac.id\n    </p>\n    <p style=\"font-size: 7.8pt; text-align: center; margin: 0; line-height: 1.3; color: #1B5E20;\">\n        Email : fmikom@unugha.ac.id Telp. : (0282) 695415, 695407 Fax : (0282) 695407\n    </p>\n</div>', '2026-06-08 16:06:47', NULL, NULL, '2026-06-08 09:06:47', '2026-06-08 09:06:47', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `surat_approval_flows`
--

CREATE TABLE `surat_approval_flows` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_id` bigint UNSIGNED NOT NULL,
  `approver_id` bigint UNSIGNED NOT NULL,
  `urutan` int NOT NULL,
  `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `keterangan` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `catatan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tanggal_aksi` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_approval_flows`
--

INSERT INTO `surat_approval_flows` (`id`, `surat_id`, `approver_id`, `urutan`, `role`, `status`, `keterangan`, `approved_at`, `catatan`, `tanggal_aksi`, `created_at`, `updated_at`) VALUES
(110, 162, 5, 1, 'admin', 'rejected_final', 'Ditolak ADMIN', '2026-06-08 11:25:58', 'lampirkan surat keterangan aktif', '2026-06-08 11:25:58', '2026-06-08 04:25:58', '2026-06-08 04:25:58'),
(111, 163, 5, 1, 'admin', 'approved', 'Validasi Admin', '2026-06-08 11:38:32', NULL, '2026-06-08 11:38:32', '2026-06-08 04:38:32', '2026-06-08 04:38:32'),
(112, 163, 20, 3, 'dekan', 'approved', 'Disetujui Dekan', '2026-06-08 11:39:43', NULL, '2026-06-08 11:39:43', '2026-06-08 04:39:43', '2026-06-08 04:39:43'),
(113, 165, 5, 1, 'admin', 'approved', 'Validasi Admin', '2026-06-08 15:13:28', NULL, '2026-06-08 15:13:28', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(114, 166, 5, 1, 'admin', 'approved', 'Validasi Admin', '2026-06-08 15:16:00', NULL, '2026-06-08 15:16:00', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(115, 166, 19, 2, 'kaprodi', 'approved', 'Disetujui Kaprodi', '2026-06-08 15:17:05', NULL, '2026-06-08 15:17:05', '2026-06-08 08:17:05', '2026-06-08 08:17:05'),
(116, 167, 5, 1, 'admin', 'approved', 'Validasi Admin', '2026-06-08 15:19:13', NULL, '2026-06-08 15:19:13', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(117, 167, 20, 3, 'dekan', 'revision_requested', 'Dikembalikan DEKAN untuk revisi', '2026-06-08 15:20:21', 'Kurang pas', '2026-06-08 15:20:21', '2026-06-08 08:20:21', '2026-06-08 08:20:21'),
(118, 171, 5, 1, 'admin', 'rejected_final', 'Ditolak ADMIN', '2026-06-08 16:04:44', 'jbji', '2026-06-08 16:04:44', '2026-06-08 09:04:44', '2026-06-08 09:04:44'),
(119, 172, 5, 1, 'admin', 'approved', 'Validasi Admin', '2026-06-08 16:06:47', NULL, '2026-06-08 16:06:47', '2026-06-08 09:06:47', '2026-06-08 09:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `surat_categories`
--

CREATE TABLE `surat_categories` (
  `id` bigint UNSIGNED NOT NULL,
  `nama` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Lucide icon name, e.g. mail, file-text',
  `warna` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tailwind color key, e.g. indigo, emerald, amber',
  `urutan` int UNSIGNED NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_categories`
--

INSERT INTO `surat_categories` (`id`, `nama`, `slug`, `deskripsi`, `icon`, `warna`, `urutan`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Surat Permohonan', 'surat-permohonan', 'Surat yang berisi permintaan resmi dari mahasiswa atau dosen.', NULL, NULL, 1, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(2, 'Surat Keterangan', 'surat-keterangan', 'Surat yang menerangkan status atau kondisi akademik.', NULL, NULL, 2, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(3, 'Surat Tugas', 'surat-tugas', 'Surat penugasan resmi untuk dosen atau staf.', NULL, NULL, 3, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(4, 'Surat Undangan', 'surat-undangan', 'Surat undangan rapat atau kegiatan resmi.', NULL, NULL, 4, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(5, 'Surat Pengantar', 'surat-pengantar', 'Surat pengantar ke instansi atau pihak lain.', NULL, NULL, 5, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(6, 'Surat Rekomendasi', 'surat-rekomendasi', 'Surat rekomendasi akademik atau non-akademik.', NULL, NULL, 6, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(7, 'Surat Keputusan', 'surat-keputusan', 'Dokumen keputusan resmi lembaga.', NULL, NULL, 7, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(8, 'Surat Edaran', 'surat-edaran', 'Penyampaian informasi resmi yang bersifat umum.', NULL, NULL, 8, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(9, 'Surat Pemberitahuan', 'surat-pemberitahuan', 'Informasi resmi yang lebih spesifik kepada penerima.', NULL, NULL, 9, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(10, 'Memo / Nota Dinas', 'memo-nota-dinas', 'Komunikasi internal formal untuk kebutuhan administratif.', NULL, NULL, 10, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31'),
(11, 'Pengumuman', 'pengumuman', 'Informasi publik internal kampus.', NULL, NULL, 11, 1, '2026-04-26 23:28:31', '2026-04-26 23:28:31');

-- --------------------------------------------------------

--
-- Table structure for table `surat_data`
--

CREATE TABLE `surat_data` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_id` bigint UNSIGNED NOT NULL,
  `field_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `field_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_data`
--

INSERT INTO `surat_data` (`id`, `surat_id`, `field_name`, `field_value`, `created_at`, `updated_at`) VALUES
(669, 162, 'semester', '8 (delapan)', '2026-06-08 04:23:10', '2026-06-08 04:23:10'),
(670, 162, 'alasan_cuti', 'Bekerja untuk melunasi biaya', '2026-06-08 04:23:10', '2026-06-08 04:23:10'),
(671, 163, 'semester', '2 (dua)', '2026-06-08 04:37:06', '2026-06-08 04:37:06'),
(672, 163, 'alasan_cuti', 'Membantu orang tua', '2026-06-08 04:37:06', '2026-06-08 04:37:06'),
(673, 164, 'tahun_lulus', '2028', '2026-06-08 04:45:31', '2026-06-08 04:45:31'),
(674, 164, 'tempat_tanggal_lahir', 'Cilacap, 20 Maret 2022', '2026-06-08 04:45:31', '2026-06-08 04:45:31'),
(675, 165, 'hari_tanggal', 'Senin, 09 Januari 2000', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(676, 165, 'waktu', '10.00 s.d selesai', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(677, 165, 'tempat', 'Curug', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(678, 165, 'perihal', 'Makan bersama keluarga FMIKOM', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(679, 165, 'lampiran_keterangan', '1', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(680, 165, 'kepada_yth', '[\"Dekan FMIKOM\"]', '2026-06-08 08:13:28', '2026-06-08 08:13:28'),
(681, 166, 'hari_tanggal', 'Senin, 10 Mei 2002', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(682, 166, 'waktu', '10.00 s.d selesai', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(683, 166, 'tempat', 'In the home', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(684, 166, 'perihal', 'Makan bersama', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(685, 166, 'lampiran_keterangan', '1', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(686, 166, 'kepada_yth', '[\"Ketua Program Studi Informatika\"]', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(687, 167, 'nama', 'Hellen Tiffani', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(688, 167, 'nim', '22527812', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(689, 167, 'prodi', 'Informatika', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(690, 167, 'perihal', 'Penempatan Lokasi PKL', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(691, 167, 'lampiran_keterangan', '1', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(692, 167, 'kepada_yth', '[\"Ketua Program Studi Informatika\"]', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(693, 168, 'semester', '5', '2026-06-08 08:43:05', '2026-06-08 08:43:05'),
(694, 168, 'alasan_cuti', 'egt4y4y', '2026-06-08 08:43:05', '2026-06-08 08:43:05'),
(695, 169, 'semester', '8', '2026-06-08 08:46:36', '2026-06-08 08:46:36'),
(696, 169, 'alasan_cuti', 'aaaaaaaaaaaaaaaaaaa', '2026-06-08 08:46:36', '2026-06-08 08:46:36'),
(697, 170, 'semester', '7', '2026-06-08 08:55:00', '2026-06-08 08:55:00'),
(698, 170, 'alasan_cuti', 'aaaaaaaaaaaaaaaaaaa', '2026-06-08 08:55:00', '2026-06-08 08:55:00'),
(699, 171, 'semester', '6 (enam)', '2026-06-08 09:00:19', '2026-06-08 09:00:19'),
(700, 171, 'alasan_cuti', 'Karena kerjaaaa', '2026-06-08 09:00:19', '2026-06-08 09:00:19'),
(701, 172, 'hari_tanggal', '56 ht', '2026-06-08 09:06:47', '2026-06-08 09:06:47'),
(702, 172, 'waktu', '67 wib', '2026-06-08 09:06:47', '2026-06-08 09:06:47'),
(703, 172, 'tempat', 'gigiu', '2026-06-08 09:06:47', '2026-06-08 09:06:47'),
(704, 172, 'perihal', 'uuuuuuuuuuu', '2026-06-08 09:06:47', '2026-06-08 09:06:47'),
(705, 172, 'lampiran_keterangan', '1', '2026-06-08 09:06:47', '2026-06-08 09:06:47'),
(706, 172, 'kepada_yth', '[\"Dekan FMIKOM\"]', '2026-06-08 09:06:47', '2026-06-08 09:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `surat_histories`
--

CREATE TABLE `surat_histories` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'created|submitted|validated|approved|rejected|generated|printed|qr_scanned|qr_revoked|revised',
  `action_label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Label ramah: Surat dibuat, Surat disetujui Kaprodi',
  `keterangan` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `meta` json DEFAULT NULL COMMENT 'Data tambahan: {status_lama, status_baru, ...}',
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_histories`
--

INSERT INTO `surat_histories` (`id`, `surat_id`, `user_id`, `action`, `action_label`, `keterangan`, `meta`, `ip_address`, `created_at`, `updated_at`) VALUES
(96, 162, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 04:23:10', '2026-06-08 04:23:10'),
(97, 162, 5, 'rejected', 'Ditolak Admin', 'lampirkan surat keterangan aktif', '{\"role\": \"admin\", \"type\": \"final_reject\"}', '127.0.0.1', '2026-06-08 04:25:58', '2026-06-08 04:25:58'),
(98, 163, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 04:37:08', '2026-06-08 04:37:08'),
(99, 163, 5, 'validated', 'Surat divalidasi admin', NULL, NULL, '127.0.0.1', '2026-06-08 04:38:33', '2026-06-08 04:38:33'),
(100, 163, 20, 'approved', 'Surat disetujui DEKAN', NULL, NULL, '127.0.0.1', '2026-06-08 04:39:52', '2026-06-08 04:39:52'),
(101, 164, 21, 'submitted', 'Surat Surat Keterangan Lulus diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 04:45:32', '2026-06-08 04:45:32'),
(102, 165, 5, 'validated', 'Surat divalidasi admin', NULL, NULL, '127.0.0.1', '2026-06-08 08:13:36', '2026-06-08 08:13:36'),
(103, 166, 5, 'validated', 'Surat divalidasi admin', NULL, NULL, '127.0.0.1', '2026-06-08 08:16:00', '2026-06-08 08:16:00'),
(104, 166, 19, 'approved', 'Surat disetujui KAPRODI', NULL, NULL, '127.0.0.1', '2026-06-08 08:17:06', '2026-06-08 08:17:06'),
(105, 167, 5, 'validated', 'Surat divalidasi admin', NULL, NULL, '127.0.0.1', '2026-06-08 08:19:13', '2026-06-08 08:19:13'),
(106, 167, 20, 'revised', 'Dikembalikan DEKAN untuk revisi', 'Kurang pas', '{\"role\": \"dekan\", \"revisi_ke\": 1}', '127.0.0.1', '2026-06-08 08:20:21', '2026-06-08 08:20:21'),
(107, 168, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 08:43:06', '2026-06-08 08:43:06'),
(108, 169, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 08:46:36', '2026-06-08 08:46:36'),
(109, 170, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 08:55:00', '2026-06-08 08:55:00'),
(110, 171, 18, 'submitted', 'Surat Surat Permohonan Cuti Mahasiswa diajukan', NULL, NULL, '127.0.0.1', '2026-06-08 09:00:19', '2026-06-08 09:00:19'),
(111, 171, 5, 'rejected', 'Ditolak Admin', 'jbji', '{\"role\": \"admin\", \"type\": \"final_reject\"}', '127.0.0.1', '2026-06-08 09:04:44', '2026-06-08 09:04:44'),
(112, 172, 5, 'validated', 'Surat divalidasi admin', NULL, NULL, '127.0.0.1', '2026-06-08 09:06:47', '2026-06-08 09:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `surat_lampirans`
--

CREATE TABLE `surat_lampirans` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_id` bigint UNSIGNED NOT NULL,
  `nama_file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipe` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_lampirans`
--

INSERT INTO `surat_lampirans` (`id`, `surat_id`, `nama_file`, `file_path`, `tipe`, `created_at`, `updated_at`) VALUES
(25, 163, 'Screenshot (26).png', 'surat-lampirans/2GBvZaTlxqbY4t0yAjLwNQxW3o3WNH7z83g7QQlk.png', 'image/png', '2026-06-08 04:37:08', '2026-06-08 04:37:08'),
(26, 171, 'Screenshot (26).png', 'surat-lampirans/dqwmWcsp08S3mYNancCyDunbqsgvuobGg7czZMME.png', 'image/png', '2026-06-08 09:00:19', '2026-06-08 09:00:19');

-- --------------------------------------------------------

--
-- Table structure for table `surat_qr_codes`
--

CREATE TABLE `surat_qr_codes` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_id` bigint UNSIGNED NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'UUID token QR',
  `status` enum('active','revoked','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `revoked_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `revoked_by` bigint UNSIGNED DEFAULT NULL,
  `revoked_at` timestamp NULL DEFAULT NULL,
  `activated_at` timestamp NULL DEFAULT NULL COMMENT 'Kapan QR mulai aktif — null jika belum disetujui',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `surat_templates`
--

CREATE TABLE `surat_templates` (
  `id` bigint UNSIGNED NOT NULL,
  `jenis_surat_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `format` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'html',
  `source_reference` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `docx_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Path file .docx yang diupload admin',
  `kop_surat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'HTML kop override (null = pakai global settings)',
  `footer_surat` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'HTML footer override',
  `css_style` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'CSS kustom untuk template ini',
  `subject` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_header` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `template_body` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `template_footer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `version` int UNSIGNED NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `updated_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_templates`
--

INSERT INTO `surat_templates` (`id`, `jenis_surat_id`, `name`, `deskripsi`, `slug`, `format`, `source_reference`, `docx_path`, `kop_surat`, `footer_surat`, `css_style`, `subject`, `template_header`, `template_body`, `template_footer`, `version`, `is_active`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(12, 21, 'Surat Undangan PKL', NULL, 'template-surat-undangan-pkl-1780825154-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"header_surat\",\"nomor\":\"{{nomor_surat}}\",\"lampiran\":\"-\",\"perihal\":\"Untuk Undangan\",\"kota\":\"{{kota_surat}}\",\"tanggal\":\"{{tanggal_surat_panjang}}\",\"font_size\":\"12pt\"},{\"type\":\"kepada_yth\",\"penerima\":[\"Dekan FMIKOM\",\"Kaprodi FMIKOM\"],\"lokasi\":\"di-\",\"tempat\":\"Tempat\",\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Salam silaturahmi dan sejahtera kami sampaikan semoga kita senantiasa mendapatkan ridlo dan pertolongan dari Allah SWT dalam menjalankan aktivitas sehari-hari. Amin.\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Sehubungan dengan tuntutan kebutuhan mahasiswa untuk mendapatkan pengalaman nyata di lapangan, maka Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap menugaskan kepada mahasiswa kami:\\t\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Nama\",\"nilai\":\"{{nama_pemohon}}\"},{\"label\":\"NIM\",\"nilai\":\"{{nim}}\"},{\"label\":\"Prodi\",\"nilai\":\"{{program_studi}}\"}],\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Untuk mengadakan riset terkait dengan skripsi yang sedang di kerjakan dengan Judul “Sistem Informasi Tata Kelola Arsip Lembaga Dokumen Pemasyarakatan Kelas IIA Gladakan Nusakambangan Berbasis Website”. Berkenaan dengan hal tersebut, maka kami mengajukan permohonan kepada Bapak/Ibu Kepala Lembaga Pemasyarakatan Kelas IIA Gladakan Nusakambangan Cilacap untuk mengizinkan mahasiswa kami melaksanakan kegiatan tersebut\",\"align\":\"justify\",\"text_indent\":0,\"font_size\":\"12pt\"},{\"type\":\"tembusan\",\"items\":[\"Ka. Prodi\",\"Bagian Akademik\"]}]', NULL, 1, 1, NULL, NULL, '2026-06-07 09:46:20', '2026-06-07 16:23:54'),
(14, 23, 'Surat Permohonan Dispensasi', NULL, 'template-surat-permohonan-dispensasi-1780825792-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"header_surat\",\"nomor\":\"{{nomor_surat}}\",\"lampiran\":\"-\",\"perihal\":\"Permohonan Dispensasi\",\"kota\":\"{{kota_surat}}\",\"tanggal\":\"{{tanggal_surat_panjang}}\",\"font_size\":\"12pt\"},{\"type\":\"kepada_yth\",\"penerima\":[\"Bapak Rifal Abdussyakur S.kom\"],\"lokasi\":\"di-\",\"tempat\":\"Tempat\",\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Salam silaturrahmi kami sampaikan semoga Bapak/Ibu Dosen di Lingkungan Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap, senantiasa dalam lindungan Allah  SWT. Amin.\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Hari/Tanggal\",\"nilai\":\"{{hari_tanggal}}\"},{\"label\":\"Waktu\",\"nilai\":\"{{waktu}}\"},{\"label\":\"Tempat\",\"nilai\":\"{{tempat}}\"}]},{\"type\":\"paragraf\",\"teks\":\"Maka kami dari Fakultas Matematika dan Ilmu Komputer UNUGHA Cilacap bermaksud mohon ijin kepada Bapak/Ibu Dosen untuk mahasiswa kami atas nama Gita Wahyuni guna mengikuti kegiatan tersebut.\",\"align\":\"justify\",\"text_indent\":0,\"font_size\":\"12pt\"}]', NULL, 1, 1, NULL, NULL, '2026-06-07 09:52:48', '2026-06-07 09:52:48'),
(15, 24, 'Surat Undangan Makan', NULL, 'template-surat-undangan-makan-1780826061-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"header_surat\",\"nomor\":\"{{nomor_surat}}\",\"lampiran\":\"-\",\"perihal\":\"Undangan\",\"kota\":\"{{kota_surat}}\",\"tanggal\":\"{{tanggal_surat_panjang}}\",\"font_size\":\"12pt\"},{\"type\":\"kepada_yth\",\"penerima\":[\"\"],\"lokasi\":\"di-\",\"tempat\":\"Tempat\",\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Sehubungan dengan adanya kegiatan Ceremonial Kelulusan Sarjana Strata Satu Fakultas Matematika dan Ilmu Komputer Universitas Nahdlatul Ulama Al Ghazali Cilacap, yang akan dilaksanakan pada\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Hari/Tanggal\",\"nilai\":\"{{hari_tanggal}}\"},{\"label\":\"Waktu\",\"nilai\":\"{{waktu}}\"},{\"label\":\"Tempat\",\"nilai\":\"{{tempat}}\"}]},{\"type\":\"paragraf\",\"teks\":\"Maka kami dari Fakultas Matematika dan Ilmu Komputer UNUGHA Cilacap bermaksud mohon ijin kepada Bapak/Ibu Dosen untuk mahasiswa kami atas nama Gita Wahyuni guna mengikuti kegiatan tersebut.\",\"align\":\"justify\",\"text_indent\":0,\"font_size\":\"12pt\"}]', NULL, 4, 1, NULL, NULL, '2026-06-07 09:57:37', '2026-06-07 16:23:54'),
(16, 25, 'Surat Keterangan Lulus', NULL, 'template-surat-keterangan-lulus-1780848158-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"judul\",\"teks\":\"SURAT KETERANGAN LULUS\",\"align\":\"center\",\"font_size\":\"12pt\",\"bold\":true,\"underline\":true},{\"type\":\"subjudul\",\"teks\":\"Nomor: {{nomor_surat}}\",\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Yang bertanda tangan di bawah ini:\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Nama\",\"nilai\":\"{{nama_penanda_tangan}}\"},{\"label\":\"NIK\",\"nilai\":\"{{nomor_induk_penanda_tangan}}\"},{\"label\":\"Jabatan\",\"nilai\":\"{{jabatan_penanda_tangan}}\"}],\"font_size\":\"12pt\",\"margin_left\":20},{\"type\":\"paragraf\",\"teks\":\"Menerangkan bahwa:\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Nama\",\"nilai\":\"{{nama_pemohon}}\"},{\"label\":\"NIM\",\"nilai\":\"{{nim}}\"},{\"label\":\"Tahun Lulus\",\"nilai\":\"{{tahun_lulus}}\"},{\"label\":\"TTL\",\"nilai\":\"{{tempat_tanggal_lahir}}\"}],\"font_size\":\"12pt\",\"margin_left\":20},{\"type\":\"paragraf\",\"teks\":\"Adalah benar benar mahasiswa alumni FMIKOM\",\"align\":\"justify\",\"text_indent\":20,\"font_size\":\"12pt\"}]', NULL, 7, 1, NULL, NULL, '2026-06-07 16:06:41', '2026-06-08 00:35:24'),
(17, 26, 'Surat Permohonan Cuti Mahasiswa', NULL, 'template-surat-permohonan-cuti-mahasiswa-1780851970-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"judul\",\"teks\":\"PERMOHONAN CUTI MAHASISWA\",\"align\":\"center\",\"font_size\":\"12pt\",\"bold\":true,\"underline\":true},{\"type\":\"subjudul\",\"teks\":\"Nomor: {{nomor_surat}}\",\"font_size\":\"12pt\"},{\"type\":\"paragraf\",\"teks\":\"Yang bertanda tangan di bawah ini:\",\"align\":\"justify\",\"text_indent\":0,\"font_size\":\"12pt\"},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Nama\",\"nilai\":\"{{nama_pemohon}}\"},{\"label\":\"NIM\",\"nilai\":\"{{nim_pemohon}}\"},{\"label\":\"Program Studi\",\"nilai\":\"{{program_studi_pemohon}}\"},{\"label\":\"Semester\",\"nilai\":\"{{semester}}\"}]},{\"type\":\"paragraf\",\"teks\":\"Dengan ini mengajukan permohonan cuti, dengan alasan dikarenakan {{alasan_cuti}}.\",\"align\":\"justify\",\"text_indent\":0},{\"type\":\"paragraf\",\"teks\":\"Demikian Surat yang saya buat, terimakasih\",\"align\":\"justify\",\"text_indent\":0}]', NULL, 1, 1, NULL, NULL, '2026-06-07 17:10:06', '2026-06-07 18:07:15'),
(18, 27, 'Surat Permohonan Cuti', NULL, 'template-surat-permohonan-cuti-1780909679-v1', 'html', NULL, NULL, NULL, NULL, '', NULL, NULL, '[{\"type\":\"header_surat\",\"nomor\":\"{{nomor_surat}}\",\"lampiran\":\"-\",\"perihal\":\"\",\"kota\":\"{{kota_surat}}\",\"tanggal\":\"{{tanggal_surat_panjang}}\"},{\"type\":\"judul\",\"teks\":\"JUDUL SURAT\",\"align\":\"center\",\"font_size\":\"12pt\",\"bold\":true,\"underline\":false},{\"type\":\"subjudul\",\"teks\":\"Nomor: {{nomor_surat}}\"},{\"type\":\"paragraf\",\"teks\":\"\",\"align\":\"justify\",\"text_indent\":0},{\"type\":\"tabel_data\",\"rows\":[{\"label\":\"Nama\",\"nilai\":\"{{nama_pemohon}}\"},{\"label\":\"NIM\",\"nilai\":\"{{nim}}\"}]},{\"type\":\"tanda_tangan\",\"kolom\":[{\"jabatan\":\"Ketua,\",\"nama\":\"\",\"nik\":\"\"}],\"posisi\":\"kanan\"},{\"type\":\"tembusan\",\"items\":[\"Ka. Prodi\",\"Bagian Akademik\"]}]', NULL, 1, 1, NULL, NULL, '2026-06-08 09:09:30', '2026-06-08 09:09:31');

-- --------------------------------------------------------

--
-- Table structure for table `surat_template_placeholders`
--

CREATE TABLE `surat_template_placeholders` (
  `id` bigint UNSIGNED NOT NULL,
  `surat_template_id` bigint UNSIGNED NOT NULL,
  `placeholder_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `source_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_required` tinyint(1) NOT NULL DEFAULT '1',
  `default_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `surat_template_placeholders`
--

INSERT INTO `surat_template_placeholders` (`id`, `surat_template_id`, `placeholder_key`, `label`, `source_type`, `source_key`, `is_required`, `default_value`, `description`, `created_at`, `updated_at`) VALUES
(77, 16, 'nim', 'Nim', 'surat_data', 'nim', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 16:06:41', '2026-06-07 16:06:41'),
(78, 16, 'tahun_lulus', 'Tahun Lulus', 'surat_data', 'tahun_lulus', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 16:06:41', '2026-06-07 16:06:41'),
(79, 16, 'tempat_tanggal_lahir', 'Tempat Tanggal Lahir', 'surat_data', 'tempat_tanggal_lahir', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 16:06:41', '2026-06-07 16:06:41'),
(80, 16, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-07 16:08:07', '2026-06-07 16:08:07'),
(83, 12, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(84, 12, 'kota_surat', 'Kota Surat', 'system', 'kota_surat', 1, 'Cilacap', 'Kota penerbitan surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(85, 12, 'tanggal_surat_panjang', 'Tanggal Surat Panjang', 'computed', 'tanggal_surat_panjang', 1, NULL, 'Tanggal surat dalam format panjang.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(86, 12, 'nama_pemohon', 'Nama Pemohon', 'user', 'name', 0, NULL, 'Nama pemohon dari akun pengguna.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(87, 12, 'nim', 'NIM', 'surat_data', 'nim', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(88, 12, 'program_studi', 'Program Studi', 'surat_data', 'program_studi', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(89, 14, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(90, 14, 'kota_surat', 'Kota Surat', 'system', 'kota_surat', 1, 'Cilacap', 'Kota penerbitan surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(91, 14, 'tanggal_surat_panjang', 'Tanggal Surat Panjang', 'computed', 'tanggal_surat_panjang', 1, NULL, 'Tanggal surat dalam format panjang.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(92, 14, 'hari_tanggal', 'Hari/Tanggal', 'surat_data', 'hari_tanggal', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(93, 14, 'waktu', 'Waktu', 'surat_data', 'waktu', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(94, 14, 'tempat', 'Tempat', 'surat_data', 'tempat', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(95, 15, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(96, 15, 'kota_surat', 'Kota Surat', 'system', 'kota_surat', 1, 'Cilacap', 'Kota penerbitan surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(97, 15, 'tanggal_surat_panjang', 'Tanggal Surat Panjang', 'computed', 'tanggal_surat_panjang', 1, NULL, 'Tanggal surat dalam format panjang.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(98, 15, 'hari_tanggal', 'Hari/Tanggal', 'surat_data', 'hari_tanggal', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(99, 15, 'waktu', 'Waktu', 'surat_data', 'waktu', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(100, 15, 'tempat', 'Tempat', 'surat_data', 'tempat', 1, NULL, 'Field dinamis surat.', '2026-06-07 16:23:54', '2026-06-07 16:23:54'),
(101, 16, 'nama_penanda_tangan', 'Nama Penanda Tangan', 'computed', 'nama_penanda_tangan', 1, NULL, 'Nama pejabat penanda tangan dari akun approver aktif.', '2026-06-07 16:23:55', '2026-06-07 18:07:15'),
(104, 17, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-07 17:10:07', '2026-06-07 17:10:07'),
(105, 17, 'nama_pemohon', 'Nama Pemohon', 'user', 'name', 0, NULL, 'Nama pemohon dari akun pengguna.', '2026-06-07 17:10:07', '2026-06-07 17:10:07'),
(107, 17, 'semester', 'Semester', 'surat_data', 'semester', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 17:10:07', '2026-06-07 17:10:07'),
(109, 17, 'alasan_cuti', 'Alasan Cuti', 'surat_data', 'alasan_cuti', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-07 17:10:07', '2026-06-07 17:10:07'),
(110, 16, 'nomor_induk_penanda_tangan', 'Nomor Induk Penanda Tangan', 'computed', 'nomor_induk_penanda_tangan', 0, NULL, 'Nomor induk pejabat penanda tangan dari akun approver aktif.', '2026-06-07 18:07:15', '2026-06-07 18:07:15'),
(111, 16, 'jabatan_penanda_tangan', 'Jabatan Penanda Tangan', 'computed', 'jabatan_penanda_tangan', 0, NULL, 'Jabatan pejabat penanda tangan dari role approver aktif.', '2026-06-07 18:07:15', '2026-06-07 18:07:15'),
(112, 17, 'nim_pemohon', 'NIM Pemohon', 'computed', 'nim_pemohon', 0, NULL, 'Nomor induk pemohon dari akun pengguna.', '2026-06-07 18:07:15', '2026-06-07 18:07:15'),
(113, 17, 'program_studi_pemohon', 'Program Studi Pemohon', 'computed', 'program_studi_pemohon', 0, NULL, 'Program studi pemohon dari akun pengguna.', '2026-06-07 18:07:15', '2026-06-07 18:07:15'),
(114, 16, 'nama_pemohon', 'Nama Pemohon', 'user', 'name', 0, NULL, 'Nama pemohon dari akun pengguna.', '2026-06-08 00:35:24', '2026-06-08 00:35:24'),
(115, 18, 'nomor_surat', 'Nomor Surat', 'surat', 'nomor_surat', 1, NULL, 'Nomor surat final yang digenerate sistem.', '2026-06-08 09:09:30', '2026-06-08 09:09:30'),
(116, 18, 'kota_surat', 'Kota Surat', 'system', 'kota_surat', 1, 'Cilacap', 'Kota penerbitan surat.', '2026-06-08 09:09:31', '2026-06-08 09:09:31'),
(117, 18, 'tanggal_surat_panjang', 'Tanggal Surat Panjang', 'computed', 'tanggal_surat_panjang', 1, NULL, 'Tanggal surat dalam format panjang.', '2026-06-08 09:09:31', '2026-06-08 09:09:31'),
(118, 18, 'nama_pemohon', 'Nama Pemohon', 'user', 'name', 0, NULL, 'Nama pemohon dari akun pengguna.', '2026-06-08 09:09:31', '2026-06-08 09:09:31'),
(119, 18, 'nim', 'Nim', 'surat_data', 'nim', 0, NULL, 'Placeholder yang dideteksi otomatis dari template.', '2026-06-08 09:09:31', '2026-06-08 09:09:31');

-- --------------------------------------------------------

--
-- Table structure for table `template_global_settings`
--

CREATE TABLE `template_global_settings` (
  `id` bigint UNSIGNED NOT NULL,
  `key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipe` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'text' COMMENT 'text|html|json|image_path',
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `template_global_settings`
--

INSERT INTO `template_global_settings` (`id`, `key`, `value`, `tipe`, `label`, `deskripsi`, `created_at`, `updated_at`) VALUES
(1, 'nama_instansi', 'Universitas Nahdlatul Ulama Al Ghazali Cilacap', 'text', 'Nama Instansi', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(2, 'nama_fakultas', 'Fakultas Matematika dan Ilmu Komputer', 'text', 'Nama Fakultas', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(3, 'singkatan', 'FMIKOM', 'text', 'Singkatan Fakultas', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(4, 'alamat', 'Jl. Kemerdekaan Barat No. 17, Cilacap Tengah', 'text', 'Alamat', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(5, 'telepon', NULL, 'text', 'Telepon', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(6, 'website', NULL, 'text', 'Website', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(7, 'email', NULL, 'text', 'Email', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(8, 'logo_path', NULL, 'image_path', 'Logo Universitas', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(9, 'kop_html', NULL, 'html', 'Kop Surat (HTML)', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(10, 'footer_html', NULL, 'html', 'Footer Surat (HTML)', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(11, 'warna_primer', '#1B5E20', 'text', 'Warna Primer Kop', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(12, 'kota_surat', 'Cilacap', 'text', 'Kota Default', NULL, '2026-05-02 22:06:19', '2026-05-02 22:06:19'),
(13, 'format_nomor', 'B/Ybk.041.10', 'text', 'Format Nomor Surat', NULL, '2026-05-02 22:06:19', '2026-06-06 04:09:04'),
(14, 'kode_prefix_nomor_surat', 'B', 'text', 'Prefix Nomor Surat', NULL, '2026-06-06 04:04:16', '2026-06-06 04:04:16'),
(15, 'kode_fakultas_nomor_surat', 'Ybk.041.10', 'text', 'Kode Fakultas Nomor Surat', NULL, '2026-06-06 04:04:16', '2026-06-06 04:04:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nomor_induk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status_approval` enum('pending','approved','rejected') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approved',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `otp_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_expires_at` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL,
  `two_factor_secret` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `two_factor_recovery_codes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `two_factor_confirmed_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role_id` bigint UNSIGNED DEFAULT NULL,
  `program_studi_id` bigint UNSIGNED DEFAULT NULL,
  `nim_nip` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `no_telepon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `nomor_induk`, `status_approval`, `email_verified_at`, `password`, `otp_code`, `otp_expires_at`, `password_changed_at`, `two_factor_secret`, `two_factor_recovery_codes`, `two_factor_confirmed_at`, `remember_token`, `created_at`, `updated_at`, `role_id`, `program_studi_id`, `nim_nip`, `no_telepon`, `foto_path`, `is_active`) VALUES
(1, 'Muchlisin Maruf', 'muchlisinmaruf@gmail.com', NULL, 'approved', '2026-03-29 13:45:30', '$2y$12$7dVeo0mbJITCFTuEF51VoOzrZADBo16Pr0NKszt/rHCfeTQWIN.1e', NULL, NULL, '2026-03-29 13:57:07', NULL, NULL, NULL, NULL, '2026-03-29 13:23:50', '2026-03-29 13:57:07', 5, NULL, NULL, NULL, NULL, 1),
(5, 'Admin', 'tiffanyhellen27@gmail.com', NULL, 'approved', '2026-06-06 04:28:49', '$2y$12$/Bz6IDi/4swjM2odIAsL7uA4K7RmJ1er/XMjEUfVMrBqbMWacwRF6', NULL, NULL, NULL, NULL, NULL, NULL, 'ZMT0ysFiQktDex0OjRLRfqRw3QfVYgLdTvz9OLmscUzYO4Iy87XkiPzdItYH', '2026-06-06 04:28:49', '2026-06-06 04:28:49', 5, NULL, NULL, NULL, NULL, 1),
(18, 'Hellen Tiffani', 'mahasiswa@test.com', '22EO10001', 'approved', NULL, '$2y$12$1T0XiJ7m68f5/KuMuo.Jnebw3XBOjUkNgizxDjO1ewDZeu0BDuEnW', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-07 17:55:45', '2026-06-08 00:17:05', 3, 1, '22EO10001', '08123456789', NULL, 1),
(19, 'Bill Gates', 'kaprodi@test.com', '12345678', 'approved', NULL, '$2y$12$WqeJJmUyMgl0Wa2ZRbs0fey57YjTuEWXzoMS8QXrINiLJKsugjzFm', NULL, NULL, NULL, NULL, NULL, NULL, 'm3swwttpylYbyZQrd0Do6TvQ4glAjtNiYJzGDqjDaPEUrMHZz76eYT2ybIOQ', '2026-06-07 17:55:45', '2026-06-08 00:17:05', 6, 1, '12345678', '08987654321', NULL, 1),
(20, 'Thomas Alva', 'dekan@test.com', '87654321', 'approved', NULL, '$2y$12$mDQEJOvvK2ab9taiijmIhOFMPzpeoFPt5y.6bsp/HmXw3zPh5dVeO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-07 17:55:45', '2026-06-08 00:17:05', 7, NULL, '87654321', '089898989898', NULL, 1),
(21, 'John Herdman', 'dosen@test.com', '88888', 'approved', NULL, '$2y$12$ARWleFSogXAcfbsfFYpnGutywdlyiuTvAZsVNY2gtjKROUwKcSxhO', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2026-06-08 00:22:04', '2026-06-08 00:22:22', 4, 1, '88888', '087878787878', NULL, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `absensi_magangs`
--
ALTER TABLE `absensi_magangs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `absensi_magangs_pendaftaran_id_foreign` (`pendaftaran_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `detail_respons`
--
ALTER TABLE `detail_respons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `detail_respons_respons_id_foreign` (`respons_id`),
  ADD KEY `detail_respons_pertanyaan_id_foreign` (`pertanyaan_id`),
  ADD KEY `detail_respons_pilihan_id_foreign` (`pilihan_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `fakultas`
--
ALTER TABLE `fakultas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `fakultas_kode_unique` (`kode`);

--
-- Indexes for table `jenis_surats`
--
ALTER TABLE `jenis_surats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jenis_surats_allowed_role_id_foreign` (`allowed_role_id`),
  ADD KEY `jenis_surats_approval_role_id_foreign` (`approval_role_id`),
  ADD KEY `jenis_surats_category_id_foreign` (`category_id`);

--
-- Indexes for table `jenis_surat_roles`
--
ALTER TABLE `jenis_surat_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jenis_surat_roles_jenis_surat_id_role_id_unique` (`jenis_surat_id`,`role_id`),
  ADD KEY `jenis_surat_roles_role_id_foreign` (`role_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_reserved_at_available_at_index` (`queue`,`reserved_at`,`available_at`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `karir_alumnis`
--
ALTER TABLE `karir_alumnis`
  ADD PRIMARY KEY (`id`),
  ADD KEY `karir_alumnis_alumni_id_foreign` (`alumni_id`);

--
-- Indexes for table `kuesioners`
--
ALTER TABLE `kuesioners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `kuesioners_pembuat_id_foreign` (`pembuat_id`);

--
-- Indexes for table `logbook_magangs`
--
ALTER TABLE `logbook_magangs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logbook_magangs_pendaftaran_id_foreign` (`pendaftaran_id`);

--
-- Indexes for table `lowongan_infos`
--
ALTER TABLE `lowongan_infos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lowongan_infos_pembuat_id_foreign` (`pembuat_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nomor_surat_sequences`
--
ALTER TABLE `nomor_surat_sequences`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nomor_surat_sequences_kode_surat_tahun_bulan_unique` (`kode_surat`,`tahun`,`bulan`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pembimbing_lapangans`
--
ALTER TABLE `pembimbing_lapangans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pembimbing_lapangans_user_id_foreign` (`user_id`),
  ADD KEY `pembimbing_lapangans_perusahaan_id_foreign` (`perusahaan_id`);

--
-- Indexes for table `pendaftaran_magangs`
--
ALTER TABLE `pendaftaran_magangs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pendaftaran_magangs_mahasiswa_id_foreign` (`mahasiswa_id`),
  ADD KEY `pendaftaran_magangs_perusahaan_id_foreign` (`perusahaan_id`),
  ADD KEY `pendaftaran_magangs_dosen_pembimbing_id_foreign` (`dosen_pembimbing_id`),
  ADD KEY `pendaftaran_magangs_pembimbing_lapangan_id_foreign` (`pembimbing_lapangan_id`),
  ADD KEY `pendaftaran_magangs_surat_tugas_id_foreign` (`surat_tugas_id`);

--
-- Indexes for table `penilaian_magangs`
--
ALTER TABLE `penilaian_magangs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `penilaian_magangs_pendaftaran_id_foreign` (`pendaftaran_id`),
  ADD KEY `penilaian_magangs_dosen_id_foreign` (`dosen_id`),
  ADD KEY `penilaian_magangs_pembimbing_lapangan_id_foreign` (`pembimbing_lapangan_id`);

--
-- Indexes for table `pertanyaan_kuesioners`
--
ALTER TABLE `pertanyaan_kuesioners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pertanyaan_kuesioners_kuesioner_id_foreign` (`kuesioner_id`);

--
-- Indexes for table `perusahaan_mitras`
--
ALTER TABLE `perusahaan_mitras`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pilihan_jawabans`
--
ALTER TABLE `pilihan_jawabans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pilihan_jawabans_pertanyaan_id_foreign` (`pertanyaan_id`);

--
-- Indexes for table `profil_alumnis`
--
ALTER TABLE `profil_alumnis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `profil_alumnis_nim_unique` (`nim`),
  ADD KEY `profil_alumnis_user_id_foreign` (`user_id`),
  ADD KEY `profil_alumnis_program_studi_id_foreign` (`program_studi_id`);

--
-- Indexes for table `program_studis`
--
ALTER TABLE `program_studis`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `program_studis_kode_unique` (`kode`),
  ADD KEY `program_studis_fakultas_id_foreign` (`fakultas_id`);

--
-- Indexes for table `respons_kuesioners`
--
ALTER TABLE `respons_kuesioners`
  ADD PRIMARY KEY (`id`),
  ADD KEY `respons_kuesioners_kuesioner_id_foreign` (`kuesioner_id`),
  ADD KEY `respons_kuesioners_alumni_id_foreign` (`alumni_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_slug_unique` (`slug`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `surats`
--
ALTER TABLE `surats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surats_qr_token_unique` (`qr_token`),
  ADD KEY `surats_jenis_surat_id_foreign` (`jenis_surat_id`),
  ADD KEY `surats_pemohon_id_foreign` (`pemohon_id`),
  ADD KEY `surats_validated_by_admin_id_foreign` (`validated_by_admin_id`),
  ADD KEY `surats_approved_by_id_foreign` (`approved_by_id`),
  ADD KEY `surats_generated_by_foreign` (`generated_by`),
  ADD KEY `surats_status_index` (`status`),
  ADD KEY `surats_tanggal_pengajuan_index` (`tanggal_pengajuan`);

--
-- Indexes for table `surat_approval_flows`
--
ALTER TABLE `surat_approval_flows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surat_approval_flows_surat_id_foreign` (`surat_id`),
  ADD KEY `surat_approval_flows_approver_id_foreign` (`approver_id`);

--
-- Indexes for table `surat_categories`
--
ALTER TABLE `surat_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surat_categories_slug_unique` (`slug`);

--
-- Indexes for table `surat_data`
--
ALTER TABLE `surat_data`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surat_data_surat_id_field_name_unique` (`surat_id`,`field_name`);

--
-- Indexes for table `surat_histories`
--
ALTER TABLE `surat_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surat_histories_surat_id_created_at_index` (`surat_id`,`created_at`),
  ADD KEY `surat_histories_user_id_index` (`user_id`);

--
-- Indexes for table `surat_lampirans`
--
ALTER TABLE `surat_lampirans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `surat_lampirans_surat_id_foreign` (`surat_id`);

--
-- Indexes for table `surat_qr_codes`
--
ALTER TABLE `surat_qr_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surat_qr_codes_token_unique` (`token`),
  ADD KEY `surat_qr_codes_revoked_by_foreign` (`revoked_by`),
  ADD KEY `surat_qr_codes_token_status_index` (`token`,`status`),
  ADD KEY `surat_qr_codes_surat_id_index` (`surat_id`);

--
-- Indexes for table `surat_templates`
--
ALTER TABLE `surat_templates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surat_templates_slug_unique` (`slug`),
  ADD KEY `surat_templates_jenis_surat_id_foreign` (`jenis_surat_id`),
  ADD KEY `surat_templates_created_by_foreign` (`created_by`),
  ADD KEY `surat_templates_updated_by_foreign` (`updated_by`);

--
-- Indexes for table `surat_template_placeholders`
--
ALTER TABLE `surat_template_placeholders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `surat_template_placeholder_unique` (`surat_template_id`,`placeholder_key`);

--
-- Indexes for table `template_global_settings`
--
ALTER TABLE `template_global_settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `template_global_settings_key_unique` (`key`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`),
  ADD KEY `users_program_studi_id_foreign` (`program_studi_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `absensi_magangs`
--
ALTER TABLE `absensi_magangs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detail_respons`
--
ALTER TABLE `detail_respons`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fakultas`
--
ALTER TABLE `fakultas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `jenis_surats`
--
ALTER TABLE `jenis_surats`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `jenis_surat_roles`
--
ALTER TABLE `jenis_surat_roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `karir_alumnis`
--
ALTER TABLE `karir_alumnis`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kuesioners`
--
ALTER TABLE `kuesioners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logbook_magangs`
--
ALTER TABLE `logbook_magangs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lowongan_infos`
--
ALTER TABLE `lowongan_infos`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `nomor_surat_sequences`
--
ALTER TABLE `nomor_surat_sequences`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pembimbing_lapangans`
--
ALTER TABLE `pembimbing_lapangans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pendaftaran_magangs`
--
ALTER TABLE `pendaftaran_magangs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `penilaian_magangs`
--
ALTER TABLE `penilaian_magangs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pertanyaan_kuesioners`
--
ALTER TABLE `pertanyaan_kuesioners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `perusahaan_mitras`
--
ALTER TABLE `perusahaan_mitras`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pilihan_jawabans`
--
ALTER TABLE `pilihan_jawabans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `profil_alumnis`
--
ALTER TABLE `profil_alumnis`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `program_studis`
--
ALTER TABLE `program_studis`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `respons_kuesioners`
--
ALTER TABLE `respons_kuesioners`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `surats`
--
ALTER TABLE `surats`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=173;

--
-- AUTO_INCREMENT for table `surat_approval_flows`
--
ALTER TABLE `surat_approval_flows`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `surat_categories`
--
ALTER TABLE `surat_categories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `surat_data`
--
ALTER TABLE `surat_data`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=707;

--
-- AUTO_INCREMENT for table `surat_histories`
--
ALTER TABLE `surat_histories`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT for table `surat_lampirans`
--
ALTER TABLE `surat_lampirans`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `surat_qr_codes`
--
ALTER TABLE `surat_qr_codes`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `surat_templates`
--
ALTER TABLE `surat_templates`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `surat_template_placeholders`
--
ALTER TABLE `surat_template_placeholders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT for table `template_global_settings`
--
ALTER TABLE `template_global_settings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `absensi_magangs`
--
ALTER TABLE `absensi_magangs`
  ADD CONSTRAINT `absensi_magangs_pendaftaran_id_foreign` FOREIGN KEY (`pendaftaran_id`) REFERENCES `pendaftaran_magangs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `detail_respons`
--
ALTER TABLE `detail_respons`
  ADD CONSTRAINT `detail_respons_pertanyaan_id_foreign` FOREIGN KEY (`pertanyaan_id`) REFERENCES `pertanyaan_kuesioners` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_respons_pilihan_id_foreign` FOREIGN KEY (`pilihan_id`) REFERENCES `pilihan_jawabans` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `detail_respons_respons_id_foreign` FOREIGN KEY (`respons_id`) REFERENCES `respons_kuesioners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jenis_surats`
--
ALTER TABLE `jenis_surats`
  ADD CONSTRAINT `jenis_surats_allowed_role_id_foreign` FOREIGN KEY (`allowed_role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `jenis_surats_approval_role_id_foreign` FOREIGN KEY (`approval_role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `jenis_surats_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `surat_categories` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jenis_surat_roles`
--
ALTER TABLE `jenis_surat_roles`
  ADD CONSTRAINT `jenis_surat_roles_jenis_surat_id_foreign` FOREIGN KEY (`jenis_surat_id`) REFERENCES `jenis_surats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `jenis_surat_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `karir_alumnis`
--
ALTER TABLE `karir_alumnis`
  ADD CONSTRAINT `karir_alumnis_alumni_id_foreign` FOREIGN KEY (`alumni_id`) REFERENCES `profil_alumnis` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `kuesioners`
--
ALTER TABLE `kuesioners`
  ADD CONSTRAINT `kuesioners_pembuat_id_foreign` FOREIGN KEY (`pembuat_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `logbook_magangs`
--
ALTER TABLE `logbook_magangs`
  ADD CONSTRAINT `logbook_magangs_pendaftaran_id_foreign` FOREIGN KEY (`pendaftaran_id`) REFERENCES `pendaftaran_magangs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lowongan_infos`
--
ALTER TABLE `lowongan_infos`
  ADD CONSTRAINT `lowongan_infos_pembuat_id_foreign` FOREIGN KEY (`pembuat_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pembimbing_lapangans`
--
ALTER TABLE `pembimbing_lapangans`
  ADD CONSTRAINT `pembimbing_lapangans_perusahaan_id_foreign` FOREIGN KEY (`perusahaan_id`) REFERENCES `perusahaan_mitras` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pembimbing_lapangans_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pendaftaran_magangs`
--
ALTER TABLE `pendaftaran_magangs`
  ADD CONSTRAINT `pendaftaran_magangs_dosen_pembimbing_id_foreign` FOREIGN KEY (`dosen_pembimbing_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pendaftaran_magangs_mahasiswa_id_foreign` FOREIGN KEY (`mahasiswa_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pendaftaran_magangs_pembimbing_lapangan_id_foreign` FOREIGN KEY (`pembimbing_lapangan_id`) REFERENCES `pembimbing_lapangans` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pendaftaran_magangs_perusahaan_id_foreign` FOREIGN KEY (`perusahaan_id`) REFERENCES `perusahaan_mitras` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `pendaftaran_magangs_surat_tugas_id_foreign` FOREIGN KEY (`surat_tugas_id`) REFERENCES `surats` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `penilaian_magangs`
--
ALTER TABLE `penilaian_magangs`
  ADD CONSTRAINT `penilaian_magangs_dosen_id_foreign` FOREIGN KEY (`dosen_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `penilaian_magangs_pembimbing_lapangan_id_foreign` FOREIGN KEY (`pembimbing_lapangan_id`) REFERENCES `pembimbing_lapangans` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `penilaian_magangs_pendaftaran_id_foreign` FOREIGN KEY (`pendaftaran_id`) REFERENCES `pendaftaran_magangs` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pertanyaan_kuesioners`
--
ALTER TABLE `pertanyaan_kuesioners`
  ADD CONSTRAINT `pertanyaan_kuesioners_kuesioner_id_foreign` FOREIGN KEY (`kuesioner_id`) REFERENCES `kuesioners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pilihan_jawabans`
--
ALTER TABLE `pilihan_jawabans`
  ADD CONSTRAINT `pilihan_jawabans_pertanyaan_id_foreign` FOREIGN KEY (`pertanyaan_id`) REFERENCES `pertanyaan_kuesioners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `profil_alumnis`
--
ALTER TABLE `profil_alumnis`
  ADD CONSTRAINT `profil_alumnis_program_studi_id_foreign` FOREIGN KEY (`program_studi_id`) REFERENCES `program_studis` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `profil_alumnis_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `program_studis`
--
ALTER TABLE `program_studis`
  ADD CONSTRAINT `program_studis_fakultas_id_foreign` FOREIGN KEY (`fakultas_id`) REFERENCES `fakultas` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `respons_kuesioners`
--
ALTER TABLE `respons_kuesioners`
  ADD CONSTRAINT `respons_kuesioners_alumni_id_foreign` FOREIGN KEY (`alumni_id`) REFERENCES `profil_alumnis` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `respons_kuesioners_kuesioner_id_foreign` FOREIGN KEY (`kuesioner_id`) REFERENCES `kuesioners` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surats`
--
ALTER TABLE `surats`
  ADD CONSTRAINT `surats_approved_by_id_foreign` FOREIGN KEY (`approved_by_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surats_generated_by_foreign` FOREIGN KEY (`generated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surats_jenis_surat_id_foreign` FOREIGN KEY (`jenis_surat_id`) REFERENCES `jenis_surats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surats_pemohon_id_foreign` FOREIGN KEY (`pemohon_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surats_validated_by_admin_id_foreign` FOREIGN KEY (`validated_by_admin_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `surat_approval_flows`
--
ALTER TABLE `surat_approval_flows`
  ADD CONSTRAINT `surat_approval_flows_approver_id_foreign` FOREIGN KEY (`approver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surat_approval_flows_surat_id_foreign` FOREIGN KEY (`surat_id`) REFERENCES `surats` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surat_data`
--
ALTER TABLE `surat_data`
  ADD CONSTRAINT `surat_data_surat_id_foreign` FOREIGN KEY (`surat_id`) REFERENCES `surats` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surat_histories`
--
ALTER TABLE `surat_histories`
  ADD CONSTRAINT `surat_histories_surat_id_foreign` FOREIGN KEY (`surat_id`) REFERENCES `surats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surat_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `surat_lampirans`
--
ALTER TABLE `surat_lampirans`
  ADD CONSTRAINT `surat_lampirans_surat_id_foreign` FOREIGN KEY (`surat_id`) REFERENCES `surats` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surat_qr_codes`
--
ALTER TABLE `surat_qr_codes`
  ADD CONSTRAINT `surat_qr_codes_revoked_by_foreign` FOREIGN KEY (`revoked_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surat_qr_codes_surat_id_foreign` FOREIGN KEY (`surat_id`) REFERENCES `surats` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `surat_templates`
--
ALTER TABLE `surat_templates`
  ADD CONSTRAINT `surat_templates_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `surat_templates_jenis_surat_id_foreign` FOREIGN KEY (`jenis_surat_id`) REFERENCES `jenis_surats` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `surat_templates_updated_by_foreign` FOREIGN KEY (`updated_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `surat_template_placeholders`
--
ALTER TABLE `surat_template_placeholders`
  ADD CONSTRAINT `surat_template_placeholders_surat_template_id_foreign` FOREIGN KEY (`surat_template_id`) REFERENCES `surat_templates` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_program_studi_id_foreign` FOREIGN KEY (`program_studi_id`) REFERENCES `program_studis` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
